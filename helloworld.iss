[Setup]
AppName=EmptyProgram
AppVerName=EmptyProgram 1
UsePreviousAppDir=false
DefaultDirName={autopf}\EmptyProgram
Uninstallable=false
OutputBaseFilename=HelloWorld
PrivilegesRequired=none

[Messages]
SetupAppTitle=My Title

[Code]
function InitializeSetup(): Boolean;
begin
	MsgBox('Hello world.', mbInformation, MB_OK);
	Result := FALSE;
end;
