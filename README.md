# FitMotion

Aplicación iOS de rutinas de ejercicio construida con SwiftUI. Permite explorar
ejercicios, filtrarlos por grupo muscular, armar una rutina y seguirla con un
temporizador. Cada ejercicio anima los fotogramas remotos del repositorio y conserva una
presentación de respaldo si la red no está disponible.

## Requisitos

- Xcode 16 o posterior
- iOS 17 o posterior

## Ejecutar

1. Abre `FitMotion.xcodeproj` en Xcode.
2. Selecciona un simulador de iPhone.
3. Presiona **Run** (`⌘R`).

No se necesitan claves de API. Las animaciones de demostración se sirven desde
el repositorio público `yuhonas/free-exercise-db` mediante jsDelivr. Para un
producto en producción se recomienda fijar una versión del repositorio o alojar
los recursos en infraestructura propia.

## Arquitectura

- `Models`: entidades de ejercicio y rutina.
- `Services`: catálogo y persistencia local con `UserDefaults`.
- `ViewModels`: estado observable de la rutina.
- `Views`: interfaz SwiftUI y reproductor de fotogramas con `AsyncImage` y `TimelineView`.

Los favoritos y la rutina se guardan en el dispositivo. El catálogo de ejemplo
queda disponible sin conexión; únicamente las imágenes animadas requieren red.
