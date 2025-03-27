# SwiftCleanArchitecture

This project demostrates some of the approaches of Clean Architecture.
It is layered as follows:

- Application layer - this layer holds Entities, UseCases and Interfaces. 
  - It can run independently of external dependencies like database, UI (SwiftUI) etc.
  - It holds the business logic that needs to be covered by Unit Tests.
- Frameworks layer - this layer holds all dependencies like databases (Firebase, Core Data, etc.)
  - The Application layer has no direct dependency to Frameworks layer. 
  - It uses Dependency Inversion principle to abstract implementation.
- Presentation layer - this layer is responsible for UI
  - UI can send requests to Application layer and waits for ApplicationState to update.
  - UI usually have Presenter that is responsible for "preprocess" data from Application into UI. 
    - Presenter formats data, connects to statePresenter and fires requests to Application layer.
- Tests layer - holds Unit tests and Mocks for Frameworks. It ususally tests UseCases.
- UITests - covers UITests (Integration tests).


