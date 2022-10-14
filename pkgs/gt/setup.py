from setuptools import setup, find_packages

setup(
    name="gt",
    version="1.0.0",
    description="python interface to butler service",
    author="Break Yang",
    author_email="breakds@wondercapital.xyz",
    packages=find_packages(),
    include_package_data=True,
    entry_points={
        "console_scripts": [
            "gt=gt.gt:main",
        ]
    },
    zip_safe=False,
    install_requires=[
        # "click",
    ],
    python_requires=">=3.6",
)
