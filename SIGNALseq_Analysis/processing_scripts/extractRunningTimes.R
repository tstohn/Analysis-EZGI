


args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 1) {
  stop("Please provide a directory path as an argument.\nUsage: Rscript extract_all_logs.R /path/to/logs/")
}

log_dir <- args[1]
log_files <- list.files(log_dir, pattern = "\\.(log|txt)$", full.names = TRUE)

if (length(log_files) == 0) {
  stop("No .log or .txt files found in the given directory.")
}

extract_tool_name <- function(cmd_line) 
{
    cmd_path <- gsub('Command being timed: "', '', cmd_line)
    cmd_path <- gsub('"$', '', cmd_path)
    tool <- basename(strsplit(cmd_path, " ")[[1]][1])
    return(tool)
}

files <- c()
tools <- c()
repeats <- c()
threads <- c()
commands <- c()
times <- c()
max_mem <- c()
for (log_file in log_files) 
{
    lines <- readLines(log_file)

    current_file <- basename(log_file)
    current_tool <- NA
    current_repeat <- NA
    current_threads <- NA

    i <- 1
    while (i <= length(lines)) 
    {
        line <- lines[i]
        
        # Match RUN line
        if (grepl("^RUN ", line)) 
        {
            # Example: RUN ESGI with 10 threads on repeat 1
            matches <- regmatches(line, regexec("^RUN (\\S+) with (\\d+) threads on repeat (\\d+)", line))[[1]]
            if (length(matches) == 4) 
            {
                current_tool <- matches[2]
                current_threads <- as.integer(matches[3])
                current_repeat <- as.integer(matches[4])
            }
            i <- i + 1
            next
        }

        # Match command
        if (grepl("Command being timed:", line)) {
            command <- extract_tool_name(line)
            elapsed <- NA
            mem_kb <- NA

            for (j in i:(i+20)) 
            {
                if (j > length(lines)) break
                if (grepl("^\\s*Elapsed \\(wall clock\\) time", lines[j])) {
                    elapsed <- sub(".*: ", "", lines[j])
                }
                if (grepl("^\\s*Maximum resident set size \\(kbytes\\)", lines[j])) {
                    mem_kb <- as.numeric(sub(".*: ", "", lines[j]))
                }
            }

            files <- c(files, current_file)
            tools <- c(tools, current_tool)
            repeats <- c(repeats, current_repeat)
            threads <- c(threads, current_threads)
            commands <- c(commands, command)
            times <- c(times, elapsed)
            max_mem <- c(max_mem, mem_kb)

            i <- j
        } else {
            i <- i + 1
        }
    }
}

# Final dataframe
df <- data.frame(
  file = files,
  tool = tools,
  run_repeat = repeats,
  threads = threads,
  command = commands,
  elapsed_time = times,
  max_resident_kb = max_mem,
  stringsAsFactors = FALSE
)

# Write to TSV
output_file = paste0(log_dir, "/summary.tsv")
write.table(df, output_file, sep = "\t", row.names = FALSE, quote = FALSE)
cat(paste("Output written to:", output_file, "\n"))