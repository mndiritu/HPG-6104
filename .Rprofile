source("renv/activate.R")
# Project .Rprofile

cat("🚀 Loading project .Rprofile for", basename(getwd()), "\n")

DEFAULT_SCRIPTS_PATH <- "~/Scripts/R/data"
FALLBACK_SCRIPTS_PATH <- "~/Documents/R/Scripts/R/data"

if (dir.exists(DEFAULT_SCRIPTS_PATH)) {
  RSCRIPTS <- DEFAULT_SCRIPTS_PATH
  cat("✅ Using Scripts directory:", RSCRIPTS, "\n")
} else if (dir.exists(FALLBACK_SCRIPTS_PATH)) {
  RSCRIPTS <- FALLBACK_SCRIPTS_PATH
  cat("⚠️ Using fallback Scripts directory:", RSCRIPTS, "\n")
} else {
  stop("No valid scripts directory found. Please clone the scripts repo.")
}

sourceDir <- function(path, trace = TRUE, ...) {
  if (!dir.exists(path)) {
    warning("Path does not exist: ", path)
    return(NULL)
  }
  files <- list.files(path, pattern = "[.][RrSsQq]$", full.names = TRUE)
  for (nm in files) {
    if (trace) cat("🔧 Sourcing:", nm, "\n")
    source(nm, ...)
  }
}

# Source project utils and RSCRIPTS
sourceDir(RSCRIPTS)

# Load and install packages (packages.R)
packages_script <- file.path(getwd(), "utils", "packages.R")
if (file.exists(packages_script)) {
  cat("📦 Sourcing packages.R from utils\n")
  source(packages_script)
} else {
  warning("packages.R not found in utils/")
}

options(stringsAsFactors = FALSE)
options(scipen = 999)
options(digits = 4)

cat("✅ Project .Rprofile loaded!\n")
