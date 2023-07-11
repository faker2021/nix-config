import os
import git
import click
import github


@click.group()
def main():
    pass


def read_token():
    home = os.path.expanduser("~")
    with open(os.path.join(home, ".ssh/tk")) as f:
        return f.read().strip()


@main.command()
def demo():
    g = github.Github(read_token())
    for repo in g.get_user().get_repos():
        print(repo.name)


def get_unpushed_commits(repo):
    head = repo.head
    branch_name = head.ref.name
    remote_commits = list(repo.iter_commits(f"remotes/origin/{branch_name}"))
    commits = list(repo.iter_commits(branch_name))
    unpushed_commits = list(filter(lambda c: c not in remote_commits, commits))
    return unpushed_commits, branch_name


def create_pr_branch(repo, latest_unpushed_commit):
    pr_branch_name = f"pr-{str(latest_unpushed_commit)[:7]}"
    pr_branch = repo.create_head(pr_branch_name)
    pr_branch.checkout()
    repo.git.push("--set-upstream", "origin", pr_branch_name)
    print(f"pr branch {pr_branch_name} created")
    return pr_branch_name


def get_github_repo(g, repo):
    remote_url = repo.remote().url
    owner, repo_name = remote_url.split("/")[-2:]
    owner = owner.split(":")[-1]
    repo_name = repo_name.split(".")[0]
    github_repo = g.get_repo(f"{owner}/{repo_name}")
    return github_repo


def create_pull_request(
    github_repo, branch_name, pr_branch_name, pr_title, pr_body, unpushed_commits
):
    pr_title = pr_title or f"pr-{branch_name}-{str(unpushed_commits[0])[:7]}"
    pr_body = pr_body or "\n".join([c.message for c in unpushed_commits])
    pr = github_repo.create_pull(
        title=pr_title, body=pr_body, head=pr_branch_name, base=branch_name
    )
    return pr


def merge_pr_and_cleanup(repo, pr, pr_branch_name, original_branch):
    pr.merge(merge_method="rebase")
    print(f"pr merged: {pr.html_url}")

    try:
        repo.git.fetch()
        # Auto stash local modifications before pull
        repo.git.pull(rebase=True, autostash=True)
    except git.GitCommandError as e:
        print(f"Error pulling changes: {e}")

    try:
        repo.git.checkout(original_branch)
        print(f"Switched to original branch: {original_branch}")
    except git.GitCommandError as e:
        print(f"Error switching to original branch: {e}")

    try:
        repo.git.branch("-d", pr_branch_name)
        print(f"Local pr branch {pr_branch_name} deleted")
    except git.GitCommandError as e:
        print(f"Error deleting local branch: {e}")

    try:
        repo.git.push("--delete", "origin", pr_branch_name)
        print(f"Remote pr branch {pr_branch_name} deleted")
    except git.GitCommandError as e:
        print(f"Error deleting remote branch: {e}")


@main.command()
@click.option(
    "path", "--path", help="the path of repo", type=click.Path(exists=True), default="."
)
@click.option("auto_merge", "--merge", help="auto_merge", is_flag=True, default=True)
@click.option("pr_title", "--title", help="pr_title", type=click.STRING, default=None)
@click.option("pr_body", "--body", help="pr_body", type=click.STRING, default=None)
def pr(path: str, auto_merge: bool, pr_title: str, pr_body: str):
    """This function will do the following things: \
    1. Get the current branch name from the local repo \
    2. Get the unpushed commits of the current branch from the local repo, and the commit messages \
    3. Create a new branch pr-xxx from the current branch \
    4. Create a pr for merging the pr-xxx branch into the current branch
    """
    token = read_token()
    repo = git.Repo.init(path=path)
    g = github.Github(token)
    unpushed_commits, branch_name = get_unpushed_commits(repo)
    if not unpushed_commits:
        print("nothing to commit")
        return

    pr_branch_name = create_pr_branch(repo, unpushed_commits[0])
    github_repo = get_github_repo(g, repo)
    pr = create_pull_request(
        github_repo, branch_name, pr_branch_name, pr_title, pr_body, unpushed_commits
    )

    print(f"pr created: {pr.html_url}")
    if auto_merge:
        merge_pr_and_cleanup(repo, pr, pr_branch_name, branch_name)

    repo.close()


if __name__ == "__main__":
    main()
