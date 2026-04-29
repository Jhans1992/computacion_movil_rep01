from __future__ import annotations

import sqlite3
import threading
import time
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from queue import Empty, Queue
from typing import Iterable


@dataclass
class RegistroMemoria:
    id: int
    agente_id: str
    tipo: str
    contenido: str
    metadata: str
    creado_en: str


class MemoryIA:
    """MemoryIA: sistema simple de memoria persistente para agentes de IA.

    Usa SQLite para mantener eventos de contexto entre ejecuciones.
    """

    def __init__(self, db_path: str = "memoria_agentes.db") -> None:
        self.db_path = Path(db_path)
        self.conn = sqlite3.connect(self.db_path, check_same_thread=False)
        self.conn.row_factory = sqlite3.Row
        self._lock = threading.Lock()
        self._inicializar_db()

    def _inicializar_db(self) -> None:
        with self._lock:
            self.conn.execute(
                """
                CREATE TABLE IF NOT EXISTS memoria (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    agente_id TEXT NOT NULL,
                    tipo TEXT NOT NULL,
                    contenido TEXT NOT NULL,
                    metadata TEXT DEFAULT '{}',
                    creado_en TEXT NOT NULL
                )
                """
            )
            self.conn.commit()

    def registrar_evento(
        self,
        agente_id: str,
        contenido: str,
        tipo: str = "evento",
        metadata: str = "{}",
    ) -> int:
        creado_en = datetime.now(timezone.utc).isoformat()
        with self._lock:
            cursor = self.conn.execute(
                """
                INSERT INTO memoria (agente_id, tipo, contenido, metadata, creado_en)
                VALUES (?, ?, ?, ?, ?)
                """,
                (agente_id, tipo, contenido, metadata, creado_en),
            )
            self.conn.commit()
            return int(cursor.lastrowid)

    def obtener_ultimo_contexto(self, agente_id: str) -> RegistroMemoria | None:
        with self._lock:
            cursor = self.conn.execute(
                """
                SELECT *
                FROM memoria
                WHERE agente_id = ?
                ORDER BY id DESC
                LIMIT 1
                """,
                (agente_id,),
            )
            row = cursor.fetchone()
        if not row:
            return None
        return RegistroMemoria(**dict(row))

    def historial(self, agente_id: str, limite: int = 20) -> Iterable[RegistroMemoria]:
        with self._lock:
            cursor = self.conn.execute(
                """
                SELECT *
                FROM memoria
                WHERE agente_id = ?
                ORDER BY id DESC
                LIMIT ?
                """,
                (agente_id, limite),
            )
            rows = cursor.fetchall()
        for row in rows:
            yield RegistroMemoria(**dict(row))

    def buscar(self, agente_id: str, termino: str, limite: int = 10) -> Iterable[RegistroMemoria]:
        with self._lock:
            cursor = self.conn.execute(
                """
                SELECT *
                FROM memoria
                WHERE agente_id = ? AND contenido LIKE ?
                ORDER BY id DESC
                LIMIT ?
                """,
                (agente_id, f"%{termino}%", limite),
            )
            rows = cursor.fetchall()
        for row in rows:
            yield RegistroMemoria(**dict(row))

    def cerrar(self) -> None:
        with self._lock:
            self.conn.close()


class MotorPersistente:
    """Proceso en segundo plano para guardar eventos sin bloquear al agente."""

    def __init__(self, memoria: MemoryIA, intervalo_segundos: float = 1.0) -> None:
        self.memoria = memoria
        self.intervalo_segundos = intervalo_segundos
        self._cola: Queue[tuple[str, str, str, str]] = Queue()
        self._detener = threading.Event()
        self._hilo = threading.Thread(target=self._bucle, daemon=True)

    def iniciar(self) -> None:
        if not self._hilo.is_alive():
            self._hilo.start()

    def registrar_async(
        self,
        agente_id: str,
        contenido: str,
        tipo: str = "evento",
        metadata: str = "{}",
    ) -> None:
        self._cola.put((agente_id, contenido, tipo, metadata))

    def _bucle(self) -> None:
        while not self._detener.is_set():
            try:
                agente_id, contenido, tipo, metadata = self._cola.get(timeout=self.intervalo_segundos)
                self.memoria.registrar_evento(agente_id, contenido, tipo=tipo, metadata=metadata)
                self._cola.task_done()
            except Empty:
                continue

    def detener(self) -> None:
        self._detener.set()
        self._hilo.join(timeout=2)


class InterfazInteligente:
    """Interfaz de comandos para consultar y registrar memoria de forma robusta."""

    def __init__(self, memoria: MemoryIA, motor: MotorPersistente) -> None:
        self.memoria = memoria
        self.motor = motor

    def registrar(self, agente_id: str, contenido: str, tipo: str = "evento") -> None:
        self.motor.registrar_async(agente_id, contenido, tipo)

    def resumen(self, agente_id: str) -> str:
        ultimo = self.memoria.obtener_ultimo_contexto(agente_id)
        if not ultimo:
            return "Sin contexto previo para este agente."
        return f"Último: [{ultimo.tipo}] {ultimo.contenido} ({ultimo.creado_en})"


def demo() -> None:
    memoria = MemoryIA()
    motor = MotorPersistente(memoria)
    interfaz = InterfazInteligente(memoria, motor)

    agente = "agente-demo"
    motor.iniciar()

    interfaz.registrar(agente, "Inicio de sesión del agente", tipo="estado")
    interfaz.registrar(agente, "Se modificó el módulo de autenticación", tipo="cambio")
    interfaz.registrar(agente, "Pendiente: escribir pruebas unitarias", tipo="tarea")

    time.sleep(1.2)

    print("=== Demo MemoryIA (modo persistente en segundo plano) ===")
    print(interfaz.resumen(agente))

    print("\nHistorial reciente:")
    for registro in memoria.historial(agente, limite=5):
        print(f"- [{registro.creado_en}] {registro.tipo}: {registro.contenido}")

    print("\nBúsqueda de 'pruebas':")
    for registro in memoria.buscar(agente, "pruebas"):
        print(f"- {registro.tipo}: {registro.contenido}")

    motor.detener()
    memoria.cerrar()


if __name__ == "__main__":
    demo()
