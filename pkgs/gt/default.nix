{ buildPythonPackage, click, PyGithub, GitPython, setuptools }:

buildPythonPackage rec {
  pname = "gt";
  version = "1.0.0";

  src = ./.;

  buildInputs = [ setuptools ];

  propagatedBuildInputs = [ click PyGithub GitPython ];

  doCheck = false;
}
