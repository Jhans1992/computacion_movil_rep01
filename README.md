# MemoryIA

**MemoryIA** es un sistema de memoria persistente para agentes de IA con ejecución robusta y registro en segundo plano. Está diseñado para reducir pérdida de contexto, recuperar estado y mantener trazabilidad de cambios y tareas.

## Características

- Persistencia local con SQLite (`memoria_agentes.db`).
- Registro por `agente_id` de eventos, estados, cambios y tareas.
- Recuperación del último contexto, historial y búsqueda por término.
- Motor asíncrono (`MotorPersistente`) para guardar eventos en segundo plano.
- Interfaz de alto nivel (`InterfazInteligente`) para integración rápida.

## Estructura principal

- `memoryia.py`
  - `MemoryIA`: capa de persistencia SQLite.
  - `MotorPersistente`: proceso/hilo para escritura asíncrona.
  - `InterfazInteligente`: capa de interacción simplificada.

## Requisitos

- Python 3.9 o superior.

## Ejecución

```bash
python memoryia.py
```

La demo crea eventos, los persiste en segundo plano y luego imprime resumen, historial y resultados de búsqueda.

## Notas de alcance

- MemoryIA no se autoautoriza en GitHub ni ejecuta acciones autónomas externas sin un integrador que lo programe explícitamente.
- Para integraciones con APIs externas, se recomienda manejar credenciales mediante variables de entorno y permisos mínimos.
