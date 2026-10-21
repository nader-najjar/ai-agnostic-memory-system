def describe_conversations(count: int) -> str:
    if count == 0:
        return "No conversations found."

    noun = "conversation" if count == 1 else "conversations"
    return f"Found {count} {noun}."
