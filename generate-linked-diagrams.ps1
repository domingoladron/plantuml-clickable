
# Our plantuml server
# If you want to use the locally installed docker version, use this url
# $plantUmlUrl = "http://localhost:8080/svg/"

# Or if you want to use the standard plantuml server, use this url
$plantUmlUrl = "http://www.plantuml.com/plantuml/svg/";

# Setup some path variables for where to find puml files and directory to write output
$dir = $PSScriptRoot
$exportDir = "$($dir)/diagrams";


# Loop over all the .puml files in the directory
Get-ChildItem -Path $dir -Filter *.puml | ForEach-Object {

    # Get the file name and content as a string
    $file = $_.Name
    $content = Get-Content -Path $_.FullName -Raw

    # Encode the content as a byte array adn then turn it into a hex string
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
    $encoded = [Convert]::ToHexString($bytes)

   
    # Use curl to call plantuml server with the encoded content
    # You can also use the"~h$encoded"
    $response = Invoke-WebRequest "$plantUmlUrl~h$encoded"

    # Check if the response is successful
    if ($response.StatusCode -eq 200) {

        # Get the svg content from the response body
        $svg = $response.Content

        # Export the svg content to a file with the same name as the .puml file in an output directory
        $svgFile = "$exportDir/$($file.Replace('.puml', '.svg'))"
        Set-Content -Path $svgFile -Value $svg

        # Display a message indicating success
        Write-Host "Successfully generated and exported svg for $file"
    }
    else {
        # Display a message indicating failure
        Write-Host "Failed to generate svg for $file"
        Write-Error "$($response.StatusCode): $($response)"
    }
}
