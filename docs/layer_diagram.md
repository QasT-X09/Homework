# Диаграмма слоёв (MVC + MVP)

```mermaid
flowchart TB
    UI[UI Layer\nScreens/Widgets]
    APP[Application Layer\nMVC Controller / MVP Presenter]
    DOMAIN[Domain Logic\nTaskService (load/add)]
    INFRA[Infrastructure\nIn-memory storage]
    ERR[Cross-cutting\nAppErrorHandler]

    UI --> APP
    APP --> DOMAIN
    DOMAIN --> INFRA
    APP --> ERR
```

## Ответственности

- **UI Layer**: отображение данных, ввод пользователя, никаких правил валидации и хранения.
- **Application Layer**:
  - **MVC Controller**: управляет состоянием экрана и вызывает бизнес-логику.
  - **MVP Presenter**: принимает действия View и возвращает View-модели через интерфейс.
- **Domain Logic**: `TaskService` содержит бизнес-операции `load` и `add`.
- **Infrastructure**: простое хранилище в памяти для задач.
- **ErrorHandler**: единый формат ошибок для UI независимо от паттерна.
