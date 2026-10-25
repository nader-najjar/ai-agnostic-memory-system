# Memory Flow

```mermaid
%%{init: {"flowchart": {"nodeSpacing": 35, "rankSpacing": 65, "curve": "linear"}}}%%
flowchart TB
    S[Source conversations] --> D[Periodic discovery]
    D -->|Save snapshot and queue its path| Q

    subgraph R[One Git repository · shared writer lock]
        Q[Queue + pending snapshots]
        P[Processed captures]
        M[Memory]
    end

    I[Periodic memorization:<br/>one snapshot] -->|Remove entry| Q
    Q --> I
    I -->|Move new or changed snapshot| P
    I -->|Write memory| M

    M --> C[Recall skill]
    R ----> B[Periodic backup:<br/>whole repository]
    T[Periodic troubleshooting] -.->|Recover abandoned runs| R
```

Discovery saves immutable conversation snapshots and queues their paths in one commit. Memorization processes the oldest queued snapshot, moves it to processed captures, updates memory, and removes its queue entry in one commit. If its content matches the latest processed capture, it deletes the pending snapshot and removes the queue entry instead. Both acquire the shared lock before changing the repository.
