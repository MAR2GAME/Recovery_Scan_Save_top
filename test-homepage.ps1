$ErrorActionPreference = "Stop"

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$htmlPath = Join-Path $root "index.html"
$cssPath = Join-Path $root "styles.css"
$appAdsPath = Join-Path $root "app-ads.txt"
$assetPaths = @(
    (Join-Path $root "assets\banner.png"),
    (Join-Path $root "assets\logo.png"),
    (Join-Path $root "assets\screen-dashboard.png"),
    (Join-Path $root "assets\screen-detail-photo.png"),
    (Join-Path $root "assets\screen-media-grid.png"),
    (Join-Path $root "assets\screen-document-detail.png"),
    (Join-Path $root "assets\screen-other-files.png")
)

Assert-True (Test-Path $htmlPath) "Missing index.html"
Assert-True (Test-Path $cssPath) "Missing styles.css"
Assert-True (Test-Path $appAdsPath) "Missing app-ads.txt"

foreach ($assetPath in $assetPaths) {
    Assert-True (Test-Path $assetPath) "Missing one or more app assets"
}

$html = Get-Content $htmlPath -Raw
$css = Get-Content $cssPath -Raw
$appAds = (Get-Content $appAdsPath -Raw).Trim()

Assert-True ($html -match "<title>Recovery: Scan & Save") "Missing page title"
Assert-True ($html -match "Recovery: Scan & Save") "Missing app name"
Assert-True ($html -match "Browse, preview, and restore recently deleted media") "Missing official hero message"
Assert-True ($html -match "feature-gallery") "Missing feature gallery section"
Assert-True ($html -match "privacy-section") "Missing privacy section"
Assert-True ($html -match "assets/screen-dashboard.png") "Dashboard asset is not wired into the page"
Assert-True ($html -match "assets/screen-other-files.png") "Other files asset is not wired into the page"
Assert-True ($html -match "assets/logo.png") "Logo is not wired into the page"
Assert-True ($html -match "assets/banner.png") "Banner is not wired into the page"
Assert-True ($html -match "scrollRestoration") "Missing scroll restoration guard"
Assert-True ($html -match "scrollTo\(0, 0\)") "Missing top-of-page reset"

Assert-True (-not ($html -match "LocShare")) "Page still contains LocShare wording"
Assert-True (-not ($html -match "File Recovery - AI Restore")) "Page still contains old File Recovery wording"
Assert-True (-not ($html -match "demo")) "Page still contains demo wording"

Assert-True ($css -match "--brand-blue") "Missing design tokens"
Assert-True ($css -match "@media \(max-width: 900px\)") "Missing responsive styles"
Assert-True ($appAds -eq "google.com, pub-3106003114382927, DIRECT, f08c47fec0942fa0") "Unexpected app-ads.txt content"

Write-Output "Recovery: Scan & Save homepage checks passed."
