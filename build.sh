#/bin/bash
unset SED 

catchErr () {
	ERROR=$?
	if [ $ERROR != 0 ]
	then
		echo "Irgendetwas stimmt mit Hasi nicht. Beende Kompilierungsprozess, Exitstatus $ERROR."
		exit $ERROR;
	fi
}

#Targets='ar71xx-generic ar71xx-nand mpc85xx-generic x86-generic x86-kvm_guest x86-64 x86-xen_domu ramips-rt305x brcm2708-bcm2708 brcm2708-bcm2709 sunxi'
Targets='ar71xx-generic ar71xx-nand ar71xx-mikrotik mpc85xx-generic x86-generic x86-kvm_guest x86-64 x86-xen_domu'
BrokenBranches='ipv6 experimental'
UnBrokenBranches='stable'
Ver='v2016.2.3+001'

Doms='hoho wtk wald wiese loe 3land ref test'


for Branch in $BrokenBranches
do
	sed s/---BRANCH---/$Branch/ site/site.conf.template >site/site.conf &&\
	for Target in $Targets
	do
		echo -ne "\033]0;Main: $Branch $Target\007"
		make -j17 BROKEN=1 GLUON_IMAGEDIR='$(GLUON_OUTPUTDIR)/gluon/'$Branch GLUON_BRANCH=$Branch GLUON_TARGET=$Target GLUON_RELEASE=$Ver V=s -Otarget
		catchErr
	done
	echo -ne "\033]0;Main: $Branch Manifest\007"
	make manifest -j17 BROKEN=1 GLUON_IMAGEDIR='$(GLUON_OUTPUTDIR)/gluon/'$Branch GLUON_BRANCH=$Branch GLUON_RELEASE=$Ver
	catchErr
done

for Branch in $UnBrokenBranches
do
	sed s/---BRANCH---/$Branch/ site/site.conf.template >site/site.conf &&\
	if [ $Branch == ipv6 ]
	then
		sed -i s/\'ipv4\ /\'ipv6\ / site/site.conf
	fi
	for Target in $Targets
	do
		echo -ne "\033]0;Main: $Branch $Target\007"
		make -j17 BROKEN=0 GLUON_IMAGEDIR='$(GLUON_OUTPUTDIR)/gluon/'$Branch GLUON_BRANCH=$Branch GLUON_TARGET=$Target GLUON_RELEASE=$Ver
		catchErr
	done
	echo -ne "\033]0;Main: $Branch Manifest\007"
	make manifest -j17 BROKEN=0 GLUON_IMAGEDIR='$(GLUON_OUTPUTDIR)/gluon/'$Branch GLUON_BRANCH=$Branch GLUON_RELEASE=$Ver
	catchErr
done
# Domänen

for Dom in $Doms
do
	for Branch in $BrokenBranches
	do
		sed s/---BRANCH---/$Branch/ site/site.conf.$Dom.template >site/site.conf &&\
		if [ $Branch == ipv6 ]
		then
			sed -i s/\'ipv4\ /\'ipv6\ / site/site.conf
		fi
		for Target in $Targets
		do
			echo -ne "\033]0;$Dom: $Branch $Target\007"
			make -j17 BROKEN=1 GLUON_IMAGEDIR='$(GLUON_OUTPUTDIR)/'$Dom/$Branch GLUON_BRANCH=$Branch GLUON_TARGET=$Target GLUON_RELEASE=$Ver
			catchErr
		done
		echo -ne "\033]0;$Dom: $Branch Manifest\007"
		make manifest -j17 BROKEN=1 GLUON_IMAGEDIR='$(GLUON_OUTPUTDIR)/'$Dom/$Branch GLUON_BRANCH=$Branch GLUON_RELEASE=$Ver
		catchErr
	done

	for Branch in $UnBrokenBranches
	do
		sed s/---BRANCH---/$Branch/ site/site.conf.$Dom.template >site/site.conf &&\
		for Target in $Targets
		do
			echo -ne "\033]0;$Dom: $Branch $Target\007"
			make -j17 BROKEN=0 GLUON_IMAGEDIR='$(GLUON_OUTPUTDIR)/'$Dom/$Branch GLUON_BRANCH=$Branch GLUON_TARGET=$Target GLUON_RELEASE=$Ver
			catchErr
		done
		echo -ne "\033]0;$Dom: $Branch Manifest\007"
		make manifest -j17 BROKEN=0 GLUON_IMAGEDIR='$(GLUON_OUTPUTDIR)/'$Dom/$Branch GLUON_BRANCH=$Branch GLUON_RELEASE=$Ver
		catchErr
	done
done

echo FERTIG!!!