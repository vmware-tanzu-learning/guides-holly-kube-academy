export TANZU_EXT_VERSION=latest

# install the Tanzu Developer Tools extension
curl -o vmware.tanzu-dev-tools-${TANZU_EXT_VERSION}.vsix "https://vmware.gallery.vsassets.io/_apis/public/gallery/publisher/vmware/extension/tanzu-dev-tools/${TANZU_EXT_VERSION}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
code-server --install-extension vmware.tanzu-dev-tools-${TANZU_EXT_VERSION}.vsix
rm vmware.tanzu-dev-tools-${TANZU_EXT_VERSION}.vsix

# install the Tanzu App Accelerator extension
curl -o vmware.tanzu-app-accelerator-${TANZU_EXT_VERSION}.vsix "https://vmware.gallery.vsassets.io/_apis/public/gallery/publisher/vmware/extension/tanzu-app-accelerator/${TANZU_EXT_VERSION}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
code-server --install-extension vmware.tanzu-app-accelerator-${TANZU_EXT_VERSION}.vsix
rm vmware.tanzu-app-accelerator-${TANZU_EXT_VERSION}.vsix