function Write-BranchName () {
    try {
        $branch = git rev-parse --abbrev-ref HEAD

        if ($branch -eq "HEAD") {
            # we're probably in detached HEAD state, so print the SHA
            $branch = git rev-parse --short HEAD
            Write-Host "($branch) " -NoNewline -ForegroundColor "red"
        }
        else {
            # we're on an actual branch, so print it
            Write-Host "($branch) " -NoNewline -ForegroundColor "blue"
        }
    } catch {
        # we'll end up here if we're in a newly initiated git repo
        Write-Host "(no branches yet) " -NoNewline -ForegroundColor "yellow"
    }
}

function prompt {
    $base = "PS "
    $path = "$($executionContext.SessionState.Path.CurrentLocation)"
    $userPrompt = "$('>' * ($nestedPromptLevel + 1)) "

    Write-Host $base -NoNewline

    if (Test-Path .git) {
        Write-Host "$path " -NoNewline -ForegroundColor "green"
        Write-BranchName
    }
    else {
        # we're not in a repo so don't bother displaying branch name/sha
        Write-Host "$path " -NoNewline -ForegroundColor "green"
    }

    return $userPrompt
}
