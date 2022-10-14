import click
import github
import git


@click.group()
def main():
    pass


def read_token():
    import os

    home = os.path.expanduser("~")
    with open(os.path.join(home, ".ssh/tk")) as f:
        return f.read()


@main.command()
# @click.option(
#     "book", "--book", help="the book id", type=click.STRING, default="default"
# )
def demo():
    g = github.Github(read_token())
    for repo in g.get_user().get_repos():
        print(repo.name)


# def pr(path: str, auto_merge: bool, pr_title: str, pr_body: str):
@main.command()
@click.option("path", "--path", help="the path of repo", type=click.STRING, default=".")
@click.option("auto_merge", "--merge", help="auto_merge", type=click.BOOL, default=True)
@click.option("pr_title", "--title", help="pr_title", type=click.STRING, default=None)
@click.option("pr_body", "--body", help="pr_body", type=click.STRING, default=None)
def pr(path: str, auto_merge: bool, pr_title: str, pr_body: str):
    """这个函数会做这些事：
    1. 从本地获取当前分支名
    2. 从本地获取当前分支的未push的commits, 以及commit message
    3. 从当前分支新建出一个 pr-xxx 分支
    4. 创建一个 pr 为 pr-xxx 分支合并到当前分支
    """
    g = github.Github(read_token())
    repo = git.Repo.init(path=path)
    head = repo.head
    branch_name = head.ref.name
    remote_commits = list(repo.iter_commits(f"remotes/origin/{branch_name}"))
    commits = list(repo.iter_commits(branch_name))
    delta_commits = list(filter(lambda c: c not in remote_commits, commits))
    delta_commit_messages = [c.message for c in delta_commits]

    if len(delta_commits) == 0:
        print("nothing to commit")
        return

    pr_branch_name = f"pr-{str(remote_commits[0])[:7]}"
    pr_branch = repo.create_head(pr_branch_name)
    pr_branch.checkout()
    try:
        repo.git.push("--set-upstream", "origin", pr_branch_name)
        print(f"pr branch {pr_branch_name} created")

        # get repo owner and repo_name
        remote_url = repo.remote().url
        owner, repo_name = remote_url.split("/")[-2:]
        owner = owner.split(":")[-1]
        repo_name = repo_name.split(".")[0]
        github_repo = g.get_repo(f"{owner}/{repo_name}")
        pr = github_repo.create_pull(
            title=pr_title or f"pr-{branch_name}-{str(remote_commits[0])[:7]}",
            body=pr_body or "\n".join(delta_commit_messages),
            head=pr_branch_name,
            base=branch_name,
        )

        print(f"pr created: {pr.html_url}")
        if auto_merge:
            # use rebase and merge
            pr.merge(merge_method="rebase")
            print(f"pr merged: {pr.html_url}")

            # git pull --rebase
            repo.remote().fetch()
            repo.remote().pull(rebase=True)

        # delete pr branch
    finally:
        # checkout to branch_name
        branch = repo.create_head(branch_name)
        branch.checkout()

        repo.delete_head(pr_branch)
        print(f"pr branch {pr_branch_name} deleted")

        if auto_merge:
            repo.git.push("--delete", "origin", pr_branch_name)
            print(f"remote pr branch {pr_branch_name} deleted")
        repo.close()


if __name__ == "__main__":
    main()
