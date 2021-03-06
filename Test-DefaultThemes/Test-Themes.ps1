#Load required libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 

$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$ThemeFile = Join-Path -Path $ScriptPath -ChildPath .\Themes\ShinyRed.xaml

[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp3"

        Title="MainWindow" Height="448.5" Width="386" Background='#4d6578'>

        <Window.Resources>
             <ResourceDictionary>
                <ResourceDictionary.MergedDictionaries>
                    <ResourceDictionary Source="$ThemeFile" /> 
                </ResourceDictionary.MergedDictionaries>
                <!-- -->
             </ResourceDictionary>
        </Window.Resources>

    <Grid>
        <Menu HorizontalAlignment="Left" Height="30" VerticalAlignment="Top" Width="378" Margin="0,0,0,0">
            <MenuItem Header="File">
                <MenuItem Header="New" />
                <MenuItem Header="Save" />
                <MenuItem Name='Quit' Header="Quit" />
            </MenuItem>
            <MenuItem Header="Edit">
                <MenuItem Header="Copy" />
                <MenuItem Header="Cut" />
                <MenuItem Header="Paste" />
            </MenuItem>
            <MenuItem Header="Help">
                <MenuItem Header="Update" />
                <MenuItem Header="WebSite" />
                <MenuItem Header="About" />
            </MenuItem>
        </Menu>
        <Button Content="Button" HorizontalAlignment="Left" Margin="10,91,0,0" VerticalAlignment="Top" Width="75"/>
        <TextBox HorizontalAlignment="Left" Height="23" Margin="10,35,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="120"/>
        <TextBlock HorizontalAlignment="Left" Margin="135,36,0,0" TextWrapping="Wrap" Text="TextBlock" VerticalAlignment="Top" />
        <TextBox HorizontalAlignment="Left" Height="23" Margin="10,63,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="120"/>
        <TextBlock HorizontalAlignment="Left" Margin="135,64,0,0" TextWrapping="Wrap" Text="TextBlock" VerticalAlignment="Top" />
        <RadioButton Content="RadioButton" HorizontalAlignment="Left" Margin="283,37,0,0" VerticalAlignment="Top"/>
        <RadioButton Name='RadioButton2' Content="RadioButton" HorizontalAlignment="Left" Margin="283,65,0,0" VerticalAlignment="Top"/>
        <Button Content="Button" HorizontalAlignment="Left" Margin="90,91,0,0" VerticalAlignment="Top" Width="75"/>
        <ToggleButton Content="ToggleButton" HorizontalAlignment="Left" Margin="170,91,0,0" VerticalAlignment="Top" Width="97" IsChecked="True"/>
        <CheckBox Content="CheckBox" HorizontalAlignment="Left" Margin="207,37,0,0" VerticalAlignment="Top" IsChecked="True"/>
        <CheckBox Content="CheckBox" HorizontalAlignment="Left" Margin="207,65,0,0" VerticalAlignment="Top"/>
        <DataGrid Name='DataGrid' HorizontalAlignment="Left" Height="100" Margin="193,116,0,0" VerticalAlignment="Top" Width="175"/>
        <GroupBox Name='GroupBox' Header="GroupBox" HorizontalAlignment="Left" Height="100" Margin="10,116,0,0" VerticalAlignment="Top" Width="178">
            <Grid HorizontalAlignment="Left" Height="80" Margin="10,10,-2,-12" VerticalAlignment="Top" Width="158">
                <RadioButton Content="RadioButton" HorizontalAlignment="Left" Margin="10,0,0,0" VerticalAlignment="Top"/>
                <RadioButton Name='GroupRadioButton' Content="RadioButton" HorizontalAlignment="Left" Margin="10,20,0,0" VerticalAlignment="Top" />
                <Button Content="Button" HorizontalAlignment="Left" Margin="73,40,0,0" VerticalAlignment="Top" Width="75"/>
            </Grid>
        </GroupBox>
        <ListBox Name='ListBox' HorizontalAlignment="Left" Height="100" Margin="10,221,0,0" VerticalAlignment="Top" Width="175"/>
        <TabControl HorizontalAlignment="Left" Height="100" Margin="193,221,0,0" VerticalAlignment="Top" Width="175">
            <TabItem Header="TabItem">
                <Grid Background="#FFE5E5E5">
                    <PasswordBox HorizontalAlignment="Left" Margin="10,41,0,0" VerticalAlignment="Top" Width="149" Password="12345678"/>
                    <Label Content="Password" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Width="125"/>
                </Grid>
            </TabItem>
            <TabItem Header="TabItem">
                <Grid Background="#FFE5E5E5"/>
            </TabItem>
        </TabControl>
        <StatusBar Name='StatusBar' HorizontalAlignment="Left" Height="21" Margin="0,390,0,0" VerticalAlignment="Top" Width="378" >
            <StatusBarItem Name='StatusBarItem1' Content="http://vcloud-lab.com" Foreground='Blue'/>
        </StatusBar>
        <ComboBox Name='ComboBox' HorizontalAlignment="Left" Margin="10,326,0,0" VerticalAlignment="Top" Width="129"/>
        <Expander Header="Expander" HorizontalAlignment="Left" Height="55" Margin="144,326,0,0" VerticalAlignment="Top" Width="100" IsExpanded="True">
            <Label Content="Example" HorizontalAlignment="Left" Margin="10,0,0,0" Width="80" Height="26"/>
        </Expander>
        <ProgressBar HorizontalAlignment="Left" Height="15" Margin="249,347,0,0" VerticalAlignment="Top" Width="119" IsIndeterminate="True"/>
        <ProgressBar HorizontalAlignment="Left" Height="14" Margin="249,367,0,0" VerticalAlignment="Top" Width="119" Value="60"/>
        <Slider HorizontalAlignment="Left" Margin="10,353,0,0" VerticalAlignment="Top" Width="129" Value="4"/>
        <ScrollBar HorizontalAlignment="Left" Margin="249,326,0,0" VerticalAlignment="Top" Orientation="Horizontal" Width="119"/>
    </Grid>
</Window>
"@

#Read the form
$Reader = (New-Object System.Xml.XmlNodeReader $xaml) 
$Form = [Windows.Markup.XamlReader]::Load($reader) 

#AutoFind all controls
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object { 
    New-Variable  -Name $_.Name -Value $Form.FindName($_.Name) -Force 
}

$DataGrid.ItemsSource = Get-Service | Select-Object Status, Name, DisplayName -First 5
$DataGrid.SelectedIndex = 0
$ListBox.ItemsSource = Get-Process | Select-Object -ExpandProperty Name -First 5 -Unique
$ListBox.SelectedIndex = 1
$ComboBox.ItemsSource = Get-ChildItem C:\ | Select-Object -ExpandProperty Name -First 5
$ComboBox.SelectedIndex = 2
$RadioButton2.IsChecked = $true
$GroupRadioButton.IsChecked = $true
#$GroupBox.Background = '#515151'
$Quit.Add_Click({$Form.Close()})

#Mandetory last line of every script to load form
[void]$Form.ShowDialog() 
