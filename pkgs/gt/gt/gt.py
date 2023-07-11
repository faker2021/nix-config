import os
import click
import git
from github import Github

def read_token():
    with open(os.path.join(os.path.expanduser("~"), ".ssh/tk")) as f:
        return f.read()

@click.group()
def main():
    pass

@main.command()
def demo():
    github_client = Github(read_token())
    for repo in github_client.get_user().get_repos():
        print(repo.name)

@main.command()
@click.option("--path", default=".", help="The path of repo")
@click.option("--merge", default=True, type=click.BOOL, help="Automerge option")
@click.option("--title", default=None, help="Title of the pull request")
@click.option("--body", default=None, help="Body of the pull request")
def pr(path: str, auto_merge: bool, pr_title: str, pr_body: str):
    github_client = Github(read_token())
    repo = git.Repo.init(path=path)
    branch_name = repo.head.ref.name
    remote_commits = list(repo.iter_commits(f"remotes/origin/{branch_name}"))
    local_commits = list(repo.iter_commits(branch_name))
    unpushed_commits = [c for c in local_commits if c not in remote_commits]

    if not unpushed_commits:
        print("Nothing to commit.")
        return

    pr_branch_name = f"pr-{str(remote_commits[0])[:7]}"
    pr_branch = repo.create_head(pr_branch_name)
    pr_branch.checkout()
    repo.git.push("--set-upstream", "origin", pr_branch_name)
    print(f"PR branch {pr_branch_name} created.")

    owner, repo_name = get_owner_and_repo_name(repo)
    github_repo = github_client.get_repo(f"{owner}/{repo_name}")

    pr = create_pr(github_repo, pr_branch_name, branch_name, unpushed_commits, pr_title, pr_body)

    print(f"PR created: {pr.html_url}")

    if auto_merge:
        merge_pr_and_pull_changes(repo, pr)

    cleanup_pr_branch(repo, branch_name, pr_branch, pr_branch_name, auto_merge)

def get_owner_and_repo_name(repo):
    remote_url = repo.remote().url
    owner, repo_name = remote_url.split("/")[-2:]
    return owner.split(":")[-1], repo_name.split(".")[0]

def create_pr(github_repo, pr_branch_name, branch_name, unpushed_commits, pr_title, pr_body):
    title = pr_title or f"pr-{branch_name}-{str(unpushed_commits[0])[:7]}"
    body = pr_body or "\n".join([c.message for c in unpushed_commits])
    return github_repo.create_pull(title=title, body=body, head=pr_branch_name, base=branch_name)

def merge_pr_and_pull_changes(repo, pr):
    pr.merge(merge_method="rebase")
    print(f"PR merged: {pr.html_url}")

    repo.remote().fetch()
    repo.remote().pull(rebase=True)

def cleanup_pr_branch(repo, branch_name, pr_branch, pr_branch_name, auto_merge):
    branch = repo.create_head(branch_name)
    branch.checkout()
    repo.delete_head(pr_branch)
    print(f"PR branch {pr_branch_name} deleted.")
    if auto_merge:
        repo.git.push("--delete", "origin", pr_branch_name)
        print(f"Remote PR branch {pr_branch_name} deleted.")
    repo.close()

if __name__ == "__main__":
    main()
