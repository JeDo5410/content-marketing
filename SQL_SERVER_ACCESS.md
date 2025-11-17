# SQL Server LocalDB Access Instructions

## Connection Details

**Server:** `(localdb)\MSSQLLocalDB`
**Authentication:** Windows Authentication (Integrated Security)
**Username:** `LAPTOP-D09527T9\Jed`
**Database Name:** *(Provided per session)*

## How to Access from WSL

Since SQL Server runs on Windows and we're working in WSL, we use **PowerShell with ADO.NET** to connect.

### Basic Query Template

```bash
powershell.exe -Command "
  \$conn = New-Object System.Data.SqlClient.SqlConnection;
  \$conn.ConnectionString = 'Server=(localdb)\\MSSQLLocalDB;Database=DATABASE_NAME_HERE;Integrated Security=true;';
  \$conn.Open();
  \$cmd = \$conn.CreateCommand();
  \$cmd.CommandText = 'YOUR_SQL_QUERY_HERE';
  \$reader = \$cmd.ExecuteReader();
  while(\$reader.Read()) {
    Write-Host \$reader[0]
  };
  \$conn.Close()
"
```

### Example: List All Tables

```bash
powershell.exe -Command "
  \$conn = New-Object System.Data.SqlClient.SqlConnection;
  \$conn.ConnectionString = 'Server=(localdb)\\MSSQLLocalDB;Database=prod_11-11-2025_schema&data;Integrated Security=true;';
  \$conn.Open();
  \$cmd = \$conn.CreateCommand();
  \$cmd.CommandText = 'SELECT name FROM sys.tables';
  \$reader = \$cmd.ExecuteReader();
  while(\$reader.Read()) {
    Write-Host \$reader[0]
  };
  \$conn.Close()
"
```

### Example: Get Row Count

```bash
powershell.exe -Command "
  \$conn = New-Object System.Data.SqlClient.SqlConnection;
  \$conn.ConnectionString = 'Server=(localdb)\\MSSQLLocalDB;Database=prod_11-11-2025_schema&data;Integrated Security=true;';
  \$conn.Open();
  \$cmd = \$conn.CreateCommand();
  \$cmd.CommandText = 'SELECT COUNT(*) FROM test_contentmarketing.ssc_main';
  \$count = \$cmd.ExecuteScalar();
  Write-Host \$count;
  \$conn.Close()
"
```

### Example: Get All Columns from a Query

```bash
powershell.exe -Command "
  \$conn = New-Object System.Data.SqlClient.SqlConnection;
  \$conn.ConnectionString = 'Server=(localdb)\\MSSQLLocalDB;Database=prod_11-11-2025_schema&data;Integrated Security=true;';
  \$conn.Open();
  \$cmd = \$conn.CreateCommand();
  \$cmd.CommandText = 'SELECT * FROM test_contentmarketing.funnel_stage';
  \$reader = \$cmd.ExecuteReader();
  \$cols = @();
  for(\$i=0; \$i -lt \$reader.FieldCount; \$i++) {
    \$cols += \$reader.GetName(\$i)
  };
  Write-Host (\$cols -join '|');
  while(\$reader.Read()) {
    \$row = @();
    for(\$i=0; \$i -lt \$reader.FieldCount; \$i++) {
      \$row += \$reader[\$i]
    };
    Write-Host (\$row -join '|')
  };
  \$conn.Close()
"
```

## Important Notes

1. **Schema Name:** All tables in the production database are in the `test_contentmarketing` schema
2. **Replace Database Name:** Always replace `DATABASE_NAME_HERE` with the actual database name provided at the start of the session
3. **Escape Backslashes:** Use `\\` for the server name in the connection string
4. **No Installation Required:** This method uses built-in Windows .NET libraries, no additional tools needed

## For AI Assistants

When starting a new chat session:
1. Ask the user for the current database name
2. Use the PowerShell ADO.NET method above to connect
3. Reference tables with the schema prefix: `test_contentmarketing.table_name`
4. Run queries using the templates provided

## Why This Works

- Uses Windows PowerShell from WSL (available by default)
- Leverages .NET's `System.Data.SqlClient` (built into Windows)
- Windows Authentication works automatically (no password needed)
- No need to install sqlcmd or SQL Server tools in WSL
