# Memory Flow

```mermaid
%%{init: {"flowchart": {"nodeSpacing": 60, "rankSpacing": 70, "curve": "linear"}}}%%
flowchart LR
    S[Source conversations] --> D[Periodic discovery]
    D --> Q

    subgraph R[One Git repository · shared writer lock]
        Q[One queue]
        M[Memory]
    end

    I[Periodic ingestion:<br/>one item] -->|Mark completed| Q
    Q --> I
    I -->|Write memory| M

    M --> C[Recall skill]
    M --> B[Periodic backup:<br/>whole repository]
```

Discovery queues conversations for ingestion of their latest available content. Ingestion writes memory and marks the item completed in one commit. Both acquire the shared lock before changing the repository.
