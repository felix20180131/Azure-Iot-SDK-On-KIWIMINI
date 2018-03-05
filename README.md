 This document describes how to prepare your development environment to run the Microsoft Azure IoT SDKs on KIWI MINI platform ,and communication with iot cloud and control BLE devices.

# 1. Hardware platform preparation.

   KIWI MINI gateway and HMT BLE sensor device, those are as follows:

   ![](https://i.imgur.com/rurn84O.png)   ![](https://i.imgur.com/8qLktgi.png)

# 2. Build development environment and Compile SDKs.
  
- Install necessary development tools on your windows PC.
  
    Ensure that the desired SecureCRT and WinSCP are installed on your windows PC. if not, you can click the follows link web page to download and install.

    - [SecureCRT](https://www.vandyke.com/download/securecrt/download.html)

        This tool contains telnet, SSH, serial etc. and the developer can use those features in development process. Of course ,the developer can use other tools which had supported those features too.
         
    
    - [WinSCP](https://winscp.net/eng/download.php)
    
        We can use this tool to access gateway system, and dump out some files to analyze issues or copy app image to system to run in development stage.
 
- Install some dependent libraries on your linux PC which will build compiling environment.

        apt-get update
		apt-get upgrade
        apt-get install -y git cmake build-essential curl libcurl4-openssl-dev libssl-dev uuid-dev gcc g++ binutils patch autoconf libcurl4-openssl-dev bzip2 flex make gettext pkg-config unzip zlib1g-dev libc6-dev subversion git libncurses5-dev gawk sharutils curl libxml-parser-perl python-yaml ocaml-nox ocaml ocaml-findlib libssl-dev

	
- How to get toolchain for compiling ?

    There are two ways to get the toolchain .One is download toolchain from [openwrt.org](http://archive.openwrt.org/barrier_breaker/14.07/ar71xx/generic). and select "OpenWrt-Toolchain-ar71xx-for-mips_34kc-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2" to download.

    ![](https://i.imgur.com/o1KQF5F.png)

    Because the toolchain contains basic libraries only,but in compiling process ,sdk depends some shared libraries which toolchain does't have ,as curl,openssl,etc. so the developoer need download those libraries source code from open source web site one by one by yourself, and compile and copy libraries and header files to toolchain directory.

    The second way is download openwrt source code and compile out the toolchain .if sdk depends some shared libraries ,the developer can configure libraries with "make menuconfig" only , when compiling , sdk will download libraries from net automatically.
    So i recommend the second way to get toolchain.
    
     -  Download openwrt source code.
   
		``` 
		      git clone  https://github.com/lixiantai/barrier_breaker.git
		``` 
     - Configure and Compile source code.
		

		        cd barrier_breaker
		        make package/symlinks
		        make defconfig
		        make menuconfig
		        make V=s 
		  The developer can reference the packages configuration(make menuconfig).the file is  "configuration\example\.config". and the developer can put this file to "<OPENWRT_ROOT_DIR>\barrier_breaker" to see the selected packages.
        

     - Known compile issue:
           
           ![](https://i.imgur.com/Ij4LAn8.png)

         The reason is caused by compiling the MAC80211 WIFI drivers with defult configuration ,but on KIWI MINI , the developer needn't to compile this type of WIFI drivers again. So i recommend that the developer doesn't to compile this WIFI drivers and use "make menuconfig" to configure openwrt by yourself.
  
    
           After comipiled successfully ,the developer can find the toolchain in this folder.
           For example:

           ![](https://i.imgur.com/bCcSPDs.png)

          ```
          cd <OPENWRT_ROOT_DIR>/barrier_breaker/bin/ar71xx
          ```
          ```
 		  tar -jxvf OpenWrt-Toolchain-ar71xx-for-mips_34kc-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2
		  ```
          
          //copy some compiled libraries to toolchain user libraries directory

		  ```
          cp -rf ../../staging_dir/target-mips_34kc_uClibc-0.9.33.2/usr/* OpenWrt-Toolchain-ar71xx-for-mips_34kc-gcc-4.8-linaro_uClibc-0.9.33.2/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/usr/
          ```

- Download Azure iot SDKs.

     You know Azure iot SDK had been implemented by many languages ,as C,Python,C#,JAVA etc. And the developer can access to [Mircrosoft Azure iot SDK](https://github.com/Azure) web site to get more details. But in this document, we foucs on Python and C Azure SDK only.
 
     - Download Azure iot SDK for Python.

           ```
           git clone --recursive https://github.com/Azure/azure-iot-sdk-python.git
           ```
     - Download Azure iot SDK for C.

		   ```
           git clone --recursive https://github.com/Azure/azure-iot-sdk-c.git
           ```

- Compile Azure iot SDKs.
          
      - Compile Azure iot SDK for Python.
         
        The developer can reference the example of "Example of Cross Compiling the Azure IoT SDK for Python.md" in SDK. 
        run "<AZURE_PYTHON_ROOT_DIR>/azure-iot-sdk-python/build_all/linux/setup.sh" to update system development environment,if done ,no need to do next time.
        
        - Compile Boostlinux module:
        
	              cd <BOOST_ROOT_DIR>
				  wget https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.gz
	              tar -xzf boost_1_64_0.tar.gz
	              cd <BOOST_ROOT_DIR>/boost_1_64_0
	              mkdir boostmlinux-1-64-0
	              mkdir boost-build
	              ./bootstrap.sh --with-libraries=python –-prefix=<BOOST_ROOT_DIR>/boost_1_64_0/boostmlinux-1-64-0


                  //edit this file to do configuration file and save, please see a example: "configuration\example\python\project-config.jam".
	              vi project-config.jam 


	              ./b2 toolset=gcc-mips --build-dir=<BOOST_ROOT_DIR>/boost_1_64_0/boost-build link=static install
        
        - Compile Azure iot sdk for Python:


	              cd <AZURE_PYTHON_ROOT_DIR>/azure-iot-sdk-python
                  //creat output directory 
	              mkdir  kiwi_out
	              cd <AZURE_PYTHON_ROOT_DIR>/azure-iot-sdk-python/build_all/linux
                  //creat a cmake configuration file
	              touch mips-34kc-gcc-4.8-toolchain-python.cmake
                  
                  //edit this file to do configuration and save, please see a example: "configuration\example\python\mips-34kc-gcc-4.8-toolchain-python.cmake".
	              vi mips-34kc-gcc-4.8-toolchain-python.cmake
	              
                  //edit build.sh and modify the line which will call "c/build_all/linux/build.sh",for example:
	              ./c/build_all/linux/build.sh --build-python $PYTHON_VERSION $* --provisioning $USE_TPM_SIM --toolchain-file "<AZURE_PYTHON_ROOT_DIR>/azure-iot-sdk-python/build_all/linux/mips-34kc-gcc-4.8-toolchain-python.cmake" --install-path-prefix "<AZURE_PYTHON_ROOT_DIR>/azure-iot-sdk-python/kiwiout"
                  //run build.sh to start compiling
	              ./build.sh

		- Known compile issues:
     
            Issue1: Error log is "relocation R_MIPS16_26 against `PyErr_Occurred' can not be used when making a shared object; recompile with -fPI",
            This means is that the developer needs to recompile Python library with "-fPIC". For example: edit "<OPENWRT_ROOT_DIR>/feeds/oldpackages/lang/python/Makefile",add "-fPIC" paramter.
              
            Issue2:	Error log is "libboost_python.a: could not read symbols:Bad Value", this reason is same as Issue1, so should modify file of "<BOOST_ROOT_DIR>/boost_1_64_0/tools/build/src/tools/gcc.jam",as:
            ![](https://i.imgur.com/vp2VHmO.png)


   - Compile Azure iot SDK for C
   
            cd <AZURE_C_ROOT_DIR>/azure-iot-sdk-c/build_all/linux
             
            //update system development environment,if done ,no need to do next time
            ./setup.sh
            //creat a cmake configuration file
            touch mips-34kc-gcc-4.8-toolchain-c.cmake
       
            //edit this file to do configuration and save, please see a example: "configuration\example\c\mips-34kc-gcc-4.8-toolchain-c.cmake".
	        vi mips-34kc-gcc-4.8-toolchain-c.cmake

            ./build.sh --toolchain-file "<AZURE_C_ROOT_DIR>/azure-iot-sdk-c/build_all/linux/mips-34kc-gcc-4.8-toolchain-c.cmake" --install-path-prefix "<AZURE_C_ROOT_DIR>/azure-iot-sdk-c/kiwiout" -cl

      Note: If you need to run sample of "iothub_client_sample_mqtt" , you need modify default connection string to yours ,as follow:

       edit iothub_client_sample_mqtt.c
         ![](https://i.imgur.com/EqAN8XU.png)

       How to get connection string ? The developer shold follow instructions in [Azure iot hub Cloud](https://portal.azure.com/#resource/subscriptions/81f3357e-37d1-4ecf-85b8-e9c4d6cc5347/resourceGroups/group2/providers/Microsoft.Devices/IotHubs/myIotHub-2018/Overview) website to creat account and regist devices.

# 3. Run SDK samples on KIWI MINI.

   Step1: power on the KIWI MINI, the developer needs to check status mode which is AP or STA. If device mode is not STA mode ,the developer shuold configure network first.
  
-     If your device is AP mode ,the gateway can broadcast own address automatically, and the developer can see the WIFI SSID (The format is "Tonly_xxx")on PC,  and connect this point ,for example:
    
     ![](https://i.imgur.com/iJ0kB1T.png)
   
     and then use "192.168.88.1" to login gateway system by telenet in SecureCRT. as:

     ![](https://i.imgur.com/OJftNma.png) 
   
     1)Set password for root account:

       ![](https://i.imgur.com/THDnzpp.png)

     2)Configure network and ensure the gateway device can access internet by connect the upside AP.
       For example:
                  ![](https://i.imgur.com/hkQMjlw.png)

      At last, this gateway is in STA mode , the upside AP will allocate the IP addr to the gateway.

-     If your device is STA mode ,you can use IP which had been allocated by upside AP and password to login gateway by SSH in SecureCRT. 
      If you forget the password , you can always press key 10 seconds on gateway, and the system will recovery to default configuration and AP mode,and then you need reconfigure network again for STA mode.

  Step2: Put compiled files into the gateway system that are running and dependent on the system. (or use "tftp-hpa" to push files to gateway system,as " tftp-hpa [IP] -m binary -c get [file]")


   - For example of Python:
   
     ![](https://i.imgur.com/r62HIUD.png)
   - For example of C:
     
     ![](https://i.imgur.com/jbjbXxH.png)

  Step3:Get connected string from Azure iot hub cloud. The developer shold follow instructions in [Azure iot hub Cloud](https://portal.azure.com/#resource/subscriptions/81f3357e-37d1-4ecf-85b8-e9c4d6cc5347/resourceGroups/group2/providers/Microsoft.Devices/IotHubs/myIotHub-2018/Overview) website to creat account and regist devices. 
  
  Step4:change permission for current files.
           
            chmod 777 . -R

  Step5:run samples.    

   - For example of Python:
    ![](https://i.imgur.com/iAf4RDv.png)
    Known issues :
                 ![](https://i.imgur.com/jTNuLQR.png)
                 Because of the Python Version is V2.7.3 ,the developer should ensure the Python version in PC is same as gateway system.Oherwise this issue will be presented.
   - For example of C:
     
          		./iothub_client_sample_mqtt



# 4. Capture air parameters form HMT sensor device on KIWI MINI.

   Ensure that HMT device is working to monitor the current air environment. you can reference the sample of "samples/CaptureAirSample.py" . you need push the sample file to KIWI MINI. and then: 
   
        python CaptureAirSample.py 6C:5A:B5:7E:9E:9B
        
        result:
               temperature: 25.2
               humidity: 52%