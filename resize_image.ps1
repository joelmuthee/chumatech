
Add-Type -AssemblyName System.Drawing

$sourcePath = "$PSScriptRoot\assets\Chumatech Logo.png"
$destPath = "$PSScriptRoot\assets\images\social-preview.jpg"
$targetWidth = 1200
$targetHeight = 630

if (-not (Test-Path $sourcePath)) {
    Write-Error "Source file not found: $sourcePath"
    exit 1
}

$image = [System.Drawing.Image]::FromFile($sourcePath)

# Create a new bitmap with the target dimensions
$bmp = New-Object System.Drawing.Bitmap $targetWidth, $targetHeight

# Create a graphics object
$graphics = [System.Drawing.Graphics]::FromImage($bmp)
$graphics.Clear([System.Drawing.Color]::White)
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Calculate scaling to fit within 1200x630 while maintaining aspect ratio
$ratioX = $targetWidth / $image.Width
$ratioY = $targetHeight / $image.Height
$ratio = [Math]::Min($ratioX, $ratioY)

$newWidth = [int]($image.Width * $ratio)
$newHeight = [int]($image.Height * $ratio)

# Center the image
$x = ($targetWidth - $newWidth) / 2
$y = ($targetHeight - $newHeight) / 2

$graphics.DrawImage($image, $x, $y, $newWidth, $newHeight)

$bmp.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)

$graphics.Dispose()
$bmp.Dispose()
$image.Dispose()

Write-Host "Image resized and saved to $destPath"
