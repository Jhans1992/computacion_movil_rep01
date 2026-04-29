# MemoryIA

Este proyecto implementa un sistema base de **memoria persistente** para agentes de IA usando Python y SQLite. Su objetivo es reducir la pérdida de contexto entre ejecuciones y facilitar que un agente recuerde:

- en qué punto quedó,
- qué cambios realizó,
- qué tareas pendientes tiene,
- y cuál fue su último estado conocido.

## Características

- Persistencia local con SQLite (`memoria_agentes.db`).
- Registro de eventos por `agente_id`.
- Recuperación del último contexto disponible.
- Consulta de historial reciente.
- Búsqueda por término dentro del contenido almacenado.

## Estructura principal

- `memoryia.py`: clase principal `MemoryIA` y una demo ejecutable.

## Requisitos

- Python 3.9 o superior.

## Ejecución

```bash
python memoryia.py
```

Al ejecutar el script se insertan eventos de ejemplo, se imprime el último contexto, el historial y una búsqueda simple.

## Integración sugerida en un agente

1. Al iniciar un agente, llamar `obtener_ultimo_contexto(agente_id)`.
2. Durante la ejecución, registrar acciones con `registrar_evento(...)`.
3. En puntos críticos, guardar resúmenes como `tipo="checkpoint"`.
4. Antes de finalizar, registrar estado final y tareas pendientes.
