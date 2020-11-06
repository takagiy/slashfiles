{ buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "qrcp";
  version = "0.7.0";
  src = fetchFromGitHub {
    owner = "claudiodangelis";
    repo = "qrcp";
    rev = version;
    sha256 = "0rx0pzy7p3dklayr2lkmyfdc00x9v4pd5xnzydbjx12hncnkpw4l"; 
  };
  subPackages = [ "." ];
  vendorSha256 = "0iffy43x3njcahrxl99a71v8p7im102nzv8iqbvd5c6m14rsckqa";
}
