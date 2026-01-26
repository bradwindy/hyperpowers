# Notion MCP Adapter

## Detection

Detection requires TWO conditions:

1. **CLAUDE.md declares Notion** - Look for `issue tracker: notion` (case-insensitive)
2. **Notion MCP tools available** - Verify by calling `notion-search` with empty query

```
# Check CLAUDE.md for explicit declaration
grep -i "issue.*tracker.*notion" CLAUDE.md

# Verify Notion MCP available (attempt search)
notion-search with query: ""
```

Returns user's workspace if configured, error if not.

**Limitation:** Requires Notion MCP server configured in Claude Code settings.

## ID Format

Notion adapter expects databases with an auto-increment ID property in PREFIX-NUMBER format:
- `HYP-2`, `PROJ-123`, `TASK-45`

The ID property must be named `ID` with type `unique_id`.

## Commands

### discover

```
# Search by issue ID
notion-search with query: "HYP-2"
# Parse results for pages with matching ID property

# Search by keyword
notion-search with query: "<keyword>"
# Filter results to database items (not standalone pages)

# Get specific issue by ID
notion-fetch with page_id: "<page-id-from-search>"
```

**ID Resolution Flow:**
1. Given `HYP-2`, search Notion for pages matching the ID
2. From search results, extract the page with `userDefined:ID` = `HYP-2`
3. Cache the parent database ID for subsequent operations

### update-status

Notion uses Status property with groups (to_do, in_progress, complete):

```
# First, fetch database schema to discover status options
notion-fetch with resource_type: "database"
              database_id: "<database-id>"
# Parse Status property to find option in "in_progress" group

# Then update the page status
notion-update-page with page_id: "<page-id>"
                   properties: {"Status": {"status": {"name": "<in-progress-option>"}}}
```

**Status Mapping (auto-detected from schema):**
- `to_do` group → first option (typically "Not started")
- `in_progress` group → first option (typically "In progress")
- `complete` group → first option (typically "Done")

### create

```
# First, fetch database schema to understand required properties
notion-fetch with resource_type: "database"
              database_id: "<database-id>"

# Create new page in database
notion-create-pages with:
  parent_type: "database"
  parent_id: "<database-id>"
  properties:
    Title: {"title": [{"text": {"content": "<title>"}}]}
    Status: {"status": {"name": "<to-do-status>"}}
  children: [
    {"paragraph": {"rich_text": [{"text": {"content": "<body>"}}]}}
  ]
```

Returns: Page ID and URL in response

**Note:** Database ID must be known from prior discover/detection. Auto-increment ID property will be assigned automatically by Notion.

### close

```
# Fetch database schema to find "complete" group status
notion-fetch with resource_type: "database"
              database_id: "<database-id>"
# Parse Status property for first option in "complete" group

# Update page to done status
notion-update-page with page_id: "<page-id>"
                   properties: {"Status": {"status": {"name": "<done-status>"}}}
```

### add-comment

Notion MCP doesn't support native comments. Append to page content instead:

```
notion-update-page with page_id: "<page-id>"
                   insert_content_after: "<last-block-id>"
                   children: [
                     {"divider": {}},
                     {"heading_3": {"rich_text": [{"text": {"content": "Progress Update - <timestamp>"}}]}},
                     {"paragraph": {"rich_text": [{"text": {"content": "<comment>"}}]}}
                   ]
```

**Note:** Get `<last-block-id>` from page content fetch. If page is empty, omit `insert_content_after` to append at end.

### get-issue-body

```
notion-fetch with page_id: "<page-id>"
# Returns page properties and content

# Extract:
# - Title from title property
# - Description from first paragraph block
# - Full content from all blocks
```

**Output format:**
```
ISSUE_BODY: [title]

[description/content blocks as text]
```

### get-branch-convention

Notion doesn't enforce conventions. Use ID prefix pattern:
- `feature/HYP-2-description`
- `feature/PROJ-123-description`

Parse prefix from issue ID to construct branch name.

## Error Handling

MCP calls may fail. Implement retry with backoff (following Jira pattern):
1. First attempt
2. Wait 1s, retry
3. Wait 2s, retry
4. Report failure with message: "Check Notion integration in Claude Code settings"

## Quirks and Limitations

1. **No native comments** - Comments appended to page content as paragraphs
2. **Requires ID property** - Database must have auto-increment ID in PREFIX-NUMBER format
3. **No database creation** - User must set up database manually
4. **Status groups required** - Status property must use Notion's status groups feature
5. **MCP availability** - Requires Notion MCP server configured
