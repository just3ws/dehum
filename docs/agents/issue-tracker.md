# Issue Tracker: Backlog.md CLI (`backlog`) & Groma.md (`groma`)

Issues for `dehum` live as Markdown files in `backlog/tasks/`, managed by the `backlog` CLI (`MrLesk/Backlog.md`), and pin to C4 architecture components in `groma/` (`MrLesk/groma.md`). Never create a literal `Backlog.md` file.

## Creating and Managing Tasks

```bash
backlog task create "Title" --priority medium
backlog task view task-001 --plain
backlog task edit task-001 --status "In Progress"
```

## Linking Tasks to Groma Architecture

```bash
groma view <source-file>
backlog task edit task-001 --modified-file <path> --add-ref <element-id>
```
