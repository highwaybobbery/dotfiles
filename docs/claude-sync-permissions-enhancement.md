# Claude Permissions Sync Enhancement Specification

[← Back to README](../README.md)

## Overview

This document specifies the enhancement of the existing `claude-sync-permissions` script to support intelligent bidirectional synchronization and interactive merging of Claude permission files between git worktrees.

## Current State Analysis

### Existing Script Functionality
- **File**: `scripts/claude-sync-permissions`
- **Language**: Ruby
- **Current Behavior**: One-way copy FROM main worktree TO current worktree
- **Alias**: `claude-sync-permissions`
- **Permission File**: `.claude/settings.local.json`

### Current Limitations
1. Only supports main → current worktree direction
2. No merge capabilities for conflicting permissions
3. Simple overwrite with confirmation (no intelligent comparison)
4. No handling of empty or missing files
5. No way to sync improvements back to main worktree

### File Structure
```json
{
  "permissions": {
    "allow": [
      "Bash(afplay:*)",
      "Bash(git rev-parse:*)",
      // ... more permissions
    ],
    "deny": []
  }
}
```

## Requirements Specification

### Core Requirements

#### 1. Smart File Comparison
- **R1.1**: Compare `.claude/settings.local.json` between main and current worktree
- **R1.2**: Handle missing files by treating as empty JSON structure: `{"permissions": {"allow": [], "deny": []}}`
- **R1.3**: Detect file states: identical, different, one-sided (only exists in one location)
- **R1.4**: Show meaningful diff summary before user makes decisions

#### 2. Context-Aware User Interface
- **R2.1**: Present options based on comparison results
- **R2.2**: When files are identical: "Files are already in sync!"
- **R2.3**: When only one file exists: Offer simple copy operation
- **R2.4**: When files differ: Present choice menu with copy and merge options
- **R2.5**: Option to preview differences before choosing action

#### 3. Interactive Merge Workflow
- **R3.1**: Use `vimdiff` for interactive merging (compatible with user's neovim setup)
- **R3.2**: Create temporary files for merge process
- **R3.3**: After merge completion, prompt user where to apply merged result:
  - Main worktree only
  - Current worktree only
  - Both worktrees
  - Cancel operation
- **R3.4**: Validate JSON structure after merge completion

#### 4. Safety and Error Handling
- **R4.1**: Create backups before any file modifications
- **R4.2**: Validate JSON structure after all operations
- **R4.3**: Graceful handling of empty/malformed JSON files
- **R4.4**: User confirmation before overwriting existing files
- **R4.5**: Option to abort operation at any step
- **R4.6**: Cleanup temporary files after operation

#### 5. Empty File Handling
- **R5.1**: Missing files treated as basic JSON structure
- **R5.2**: Empty files converted to valid JSON structure
- **R5.3**: Preserve existing JSON formatting when possible
- **R5.4**: Merge operations work even when one side is empty

## Technical Design

### Algorithm Flow

```
1. START: claude-sync-permissions
2. Detect worktree structure (reuse existing logic)
3. Locate permission files in both worktrees
4. Handle missing files → create empty JSON structure
5. Compare files
6. IF identical → "Files in sync" → EXIT
7. IF one-sided → Offer copy operation
8. IF different → Present choice menu:
   - Copy main → current
   - Copy current → main  
   - Merge interactively
   - Show differences
9. Execute chosen operation
10. IF merge chosen:
    a. Create temporary files
    b. Launch vimdiff
    c. Prompt for application locations
    d. Apply merged result
11. Validate results
12. Cleanup temporary files
13. END
```

### User Interaction Patterns

#### Choice Menu Format
```
Claude Permission Files Status: DIFFERENT

Options:
1) Copy main worktree → current worktree
2) Copy current worktree → main worktree
3) Merge files interactively
4) Show differences first
5) Cancel

Choose (1-5):
```

#### Merge Application Prompt
```
Merge completed successfully.

Apply merged settings to:
1) Main worktree only
2) Current worktree only  
3) Both worktrees
4) Cancel (discard merge)

Choose (1-4):
```

### File Operations

#### Backup Strategy
- Create `.bak` files before any modification
- Backup filename format: `.claude/settings.local.json.bak.TIMESTAMP`
- Cleanup old backups (keep last 5)

#### JSON Validation
- Parse JSON after every modification
- Pretty-print JSON to maintain readability
- Validate required structure (`permissions.allow`, `permissions.deny`)
- Handle malformed JSON gracefully

#### Temporary File Management
- Use system temp directory for merge files
- Naming pattern: `claude_merge_main_TIMESTAMP.json`, `claude_merge_current_TIMESTAMP.json`
- Cleanup temp files on exit (success or failure)

### Integration Points

#### Vimdiff Integration
- Command: `vimdiff temp_main.json temp_current.json temp_merged.json`
- Three-way merge: main | current | result
- User merges in familiar vim environment
- Script waits for vimdiff completion

#### Error Handling
- Git worktree detection failures
- File permission issues
- JSON parsing errors
- Vimdiff launch failures
- Disk space issues

## Implementation Notes

### Ruby-Specific Considerations
- Use `JSON.parse` and `JSON.pretty_generate` for JSON handling
- `FileUtils` for file operations and backups
- `Tempfile` class for temporary file management
- `system()` calls for vimdiff execution
- Proper error handling with rescue blocks

### Testing Scenarios
1. **Normal Operation**: Both files exist and differ
2. **Empty States**: Missing files, empty files, malformed JSON
3. **Identical Files**: No changes needed
4. **One-sided**: File exists in only one worktree
5. **Error Conditions**: Permission issues, invalid JSON, vimdiff failures
6. **User Cancellation**: Abort at various stages

### Future Enhancements
- Support for other diff/merge tools (beyond vimdiff)
- Batch operations across multiple worktrees
- Integration with git hooks for automatic sync
- Configuration file for user preferences
- Dry-run mode for preview without changes

## Implementation Priority

### Phase 1: Core Enhancement
- Smart comparison logic
- Context-aware menu system
- Basic merge workflow with vimdiff

### Phase 2: Safety Features
- Backup system
- JSON validation
- Error handling improvements

### Phase 3: Polish
- Better user experience
- Cleanup and optimization
- Documentation and testing

## Success Criteria

The enhanced script will be considered successful when:
1. All existing functionality is preserved (backward compatibility)
2. Users can intelligently sync permissions in both directions
3. Interactive merging works seamlessly with vimdiff
4. Empty/missing files are handled gracefully
5. All operations are safe with proper backups and validation
6. User experience is intuitive and context-aware

---

This specification provides the complete blueprint for enhancing the claude-sync-permissions script while maintaining the existing ecosystem's simplicity and reliability.