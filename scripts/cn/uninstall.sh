#!/bin/bash

function uninstall()
{
	for container_name in phala-node phala-pruntime phala-pherry phala-pruntime-bench phala-sgx_detect
	do
		if [ ! -z $(docker container ls -q -f "name=$container_name") ]; then
			docker container stop $container_name
			docker container rm --force $container_name
			case $container_name in
				phala-node)
					docker image rm $(awk -F "=" 'NR==1 {print $2}' $installdir/.env)
					if [ -d $(awk -F '[=:]' 'NR==4 {print $2}' $installdir/.env) ]; then rm -rf $(awk -F '[=:]' 'NR==4 {print $2}' $installdir/.env);fi
					;;
				phala-pruntime)
					docker image rm $(awk -F "=" 'NR==2 {print $2}' $installdir/.env)
					if [ -d $(awk -F '[=:]' 'NR==5 {print $2}' $installdir/.env) ]; then rm -rf $(awk -F '[=:]' 'NR==5 {print $2}' $installdir/.env);fi
					;;
				phala-pherry)
					docker image rm $(awk -F "=" 'NR==3 {print $2}' $installdir/.env) 
					;;
				phala-pruntime-bench)
					docker image rm phalanetwork/phala-dev-pruntime-bench
					;;
				phala-sgx_detect)
					docker image rm swr.cn-east-3.myhuaweicloud.com/phala/phala-sgx_detect:latest
					;;
				*)
					break
			esac
		fi
	done
	remove_dirver
	rm -rf $installdir
	rm /usr/bin/phala

	log_success "---------------删除 phala 挖矿套件成功---------------"
}
