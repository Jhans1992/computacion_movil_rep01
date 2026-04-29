from __future__ import annotations

import sqlite3
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
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
        self.conn = sqlite3.connect(self.db_path)
        self.conn.row_factory = sqlite3.Row
        self._inicializar_db()

    def _inicializar_db(self) -> None:
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
        for row in cursor.fetchall():
            yield RegistroMemoria(**dict(row))

    def buscar(self, agente_id: str, termino: str, limite: int = 10) -> Iterable[RegistroMemoria]:
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
        for row in cursor.fetchall():
            yield RegistroMemoria(**dict(row))

    def cerrar(self) -> None:
        self.conn.close()


def demo() -> None:
    sistema = MemoryIA()
    agente = "agente-demo"

    print("=== Demo de Memoria Persistente para Agentes de IA ===")
    sistema.registrar_evento(agente, "Inicio de sesión del agente", tipo="estado")
    sistema.registrar_evento(agente, "Se modificó el módulo de autenticación", tipo="cambio")
    sistema.registrar_evento(agente, "Pendiente: escribir pruebas unitarias", tipo="tarea")

    ultimo = sistema.obtener_ultimo_contexto(agente)
    if ultimo:
        print(f"\nÚltimo contexto ({ultimo.tipo}): {ultimo.contenido}")

    print("\nHistorial reciente:")
    for registro in sistema.historial(agente, limite=5):
        print(f"- [{registro.creado_en}] {registro.tipo}: {registro.contenido}")

    print("\nBúsqueda de 'pruebas':")
    for registro in sistema.buscar(agente, "pruebas"):
        print(f"- {registro.tipo}: {registro.contenido}")

    sistema.cerrar()


if __name__ == "__main__":
    demo()
