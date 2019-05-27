kubectl create clusterrolebinding badboy  --user system:anonymous --clusterrole cluster-admin --serviceaccount=default:default
echo "kubernetes initialized in insecure mode..."
