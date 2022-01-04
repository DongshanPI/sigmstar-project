ifeq ($(LINUX_FLASH_TYPE), emmc)
TARGET_SCRIPT:=$(LINUX_FLASH_TYPE)_init_script $(foreach n,$(LINUX_IMAGE_LIST),$(n)_$(LINUX_FLASH_TYPE)_$($(n)$(FSTYPE))_script) $(LINUX_FLASH_TYPE)_config_script
TARGET_SCRIPT+=$(foreach n,$(IMAGE_LIST),$(n)_$(FLASH_TYPE)_$($(n)$(FSTYPE))_script)
else
TARGET_SCRIPT:=$(foreach n,$(IMAGE_LIST),$(n)_$(FLASH_TYPE)_$($(n)$(FSTYPE))_script) $(FLASH_TYPE)_config_script
endif

TARGET_FS:=$(filter-out $(patsubst %_fs__,%,$(filter %_fs__, $(foreach n,$(IMAGE_LIST),$(n)_fs_$($(n)$(FSTYPE))_))), $(IMAGE_LIST))

SCRIPTDIR:=$(IMAGEDIR)/scripts

scripts:
	mkdir -p $(SCRIPTDIR)
	$(MAKE) $(TARGET_SCRIPT)
	@echo -e $(foreach n,$(IMAGE_LIST),estar scripts/[[$(n)\\n) >> $(IMAGEDIR)/auto_update.txt
	if [ $(LINUX_FLASH_TYPE) == "emmc" ]; then \
		echo estar scripts/init_emmc >> $(IMAGEDIR)/auto_update.txt; \
		echo -e $(foreach n,$(LINUX_IMAGE_LIST),estar scripts/[[$(n)\\n) >> $(IMAGEDIR)/auto_update.txt; \
	fi
	@echo estar scripts/set_config >> $(IMAGEDIR)/auto_update.txt
	@echo saveenv >> $(IMAGEDIR)/auto_update.txt
	@echo printenv >> $(IMAGEDIR)/auto_update.txt
	@echo reset >> $(IMAGEDIR)/auto_update.txt

#for spi nor flash kernel.
kernel_nor__script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo mxp r.info KERNEL >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo sf probe 0 >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo tftp $(TFTPDOWNLOADADDR) $(patsubst %_nor__script,%,$@) >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo sf erase \$${sf_part_start} \$${sf_part_size} >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo sf write $(TFTPDOWNLOADADDR) \$${sf_part_start} \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo setenv sf_kernel_start \$${sf_part_start} >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo setenv sf_kernel_size \$${sf_part_size} >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo setenv bootcmd \' bootlogo 0 0 0 0 0\; $(wifi24mclkcmd)\; $(wifirstoffcmd)\; sf probe 0\;$(kernel$(BOOTCMD)) $(rootfs$(BOOTCMD)) $(wifirstoncmd)\; bootm $(KERNELBOOTADDR) >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo setenv dispout $(DISP_OUT_NAME) >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo saveenv >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo saveenv >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)

uboot_nor__script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[uboot
	@echo mxp r.info UBOOT >> $(SCRIPTDIR)/[[uboot
	@echo sf probe 0 >> $(SCRIPTDIR)/[[uboot
	@echo tftp $(TFTPDOWNLOADADDR) boot/u-boot.xz.img.bin >> $(SCRIPTDIR)/[[uboot
	@echo sf erase \$${sf_part_start} \$${sf_part_size} >> $(SCRIPTDIR)/[[uboot
	@echo sf write $(TFTPDOWNLOADADDR) \$${sf_part_start} \$${filesize} >> $(SCRIPTDIR)/[[uboot
	@echo "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[uboot

logo_nor__script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[logo
	@echo mxp r.info LOGO >> $(SCRIPTDIR)/[[logo
	@echo sf probe 0 >> $(SCRIPTDIR)/[[logo
	@echo tftp $(TFTPDOWNLOADADDR) logo >> $(SCRIPTDIR)/[[logo
	@echo sf erase \$${sf_part_start} \$${sf_part_size} >> $(SCRIPTDIR)/[[logo
	@echo sf write $(TFTPDOWNLOADADDR) \$${sf_part_start} \$${filesize} >> $(SCRIPTDIR)/[[logo
	@echo "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[logo

ipl_nor__script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo mxp r.info IPL >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo sf probe 0 >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo tftp $(TFTPDOWNLOADADDR) boot/$(notdir $(ipl$(RESOUCE))) >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo sf erase \$${sf_part_start} \$${sf_part_size} >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo sf write $(TFTPDOWNLOADADDR) \$${sf_part_start} \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo  "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)

boot_nor__script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo sf probe 0 >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo tftp $(TFTPDOWNLOADADDR) boot.bin >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo sf erase 0 \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo sf write $(TFTPDOWNLOADADDR) 0 \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo mxp t.load >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)

ipl_cust_nor__script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo mxp r.info IPL_CUST >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo sf probe 0 >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo tftp $(TFTPDOWNLOADADDR) boot/$(notdir $(ipl_cust$(RESOUCE))) >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo sf erase \$${sf_part_start} \$${sf_part_size} >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo sf write $(TFTPDOWNLOADADDR) \$${sf_part_start} \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo  "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)

mxp_nor__script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo mxp t.init >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo tftp $(TFTPDOWNLOADADDR) boot/MXP_SF.bin >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo mxp t.update $(TFTPDOWNLOADADDR) >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo mxp t.load >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)
	@echo  "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[$(patsubst %_nor__script,%,$@)


%_nor_squashfs_script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[$(patsubst %_nor_squashfs_script,%,$@)
	@echo mxp r.info $(patsubst %_nor_squashfs_script,%,$@) >> $(SCRIPTDIR)/[[$(patsubst %_nor_squashfs_script,%,$@)
	@echo sf probe 0 >> $(SCRIPTDIR)/[[$(patsubst %_nor_squashfs_script,%,$@)
	@echo tftp $(TFTPDOWNLOADADDR) $(patsubst %_nor_squashfs_script,%,$@).sqfs >> $(SCRIPTDIR)/[[$(patsubst %_nor_squashfs_script,%,$@)
	@echo sf erase \$${sf_part_start} \$${sf_part_size} >> $(SCRIPTDIR)/[[$(patsubst %_nor_squashfs_script,%,$@)
	@echo sf write $(TFTPDOWNLOADADDR) \$${sf_part_start} \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_nor_squashfs_script,%,$@)
	@echo  "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[$(patsubst %_nor_squashfs_script,%,$@)

%_nor_ramfs_script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[$(patsubst %_nor_ramfs_script,%,$@)
	@echo mxp r.info $(patsubst %_nor_ramfs_script,%,$@) >> $(SCRIPTDIR)/[[$(patsubst %_nor_ramfs_script,%,$@)
	@echo sf probe 0 >> $(SCRIPTDIR)/[[$(patsubst %_nor_ramfs_script,%,$@)
	@echo tftp $(TFTPDOWNLOADADDR) $(patsubst %_nor_ramfs_script,%,$@).ramfs >> $(SCRIPTDIR)/[[$(patsubst %_nor_ramfs_script,%,$@)
	@echo sf erase \$${sf_part_start} \$${sf_part_size} >> $(SCRIPTDIR)/[[$(patsubst %_nor_ramfs_script,%,$@)
	@echo sf write $(TFTPDOWNLOADADDR) \$${sf_part_start} \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_nor_ramfs_script,%,$@)
	@echo setenv initrd_high ${INITRAMFSLOADADDR} >> $(SCRIPTDIR)/[[$(patsubst %_nor_ramfs_script,%,$@)
	@echo setenv initrd_size \$${sf_part_size} >> $(SCRIPTDIR)/[[$(patsubst %_nor_ramfs_script,%,$@)
	@echo saveenv >> $(SCRIPTDIR)/[[$(patsubst %_nor_ramfs_script,%,$@)
	@echo saveenv >> $(SCRIPTDIR)/[[$(patsubst %_nor_ramfs_script,%,$@)
	@echo  "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[$(patsubst %_nor_ramfs_script,%,$@)

%_nor_jffs2_script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[$(patsubst %_nor_jffs2_script,%,$@)
	@echo mxp r.info $(patsubst %_nor_jffs2_script,%,$@) >> $(SCRIPTDIR)/[[$(patsubst %_nor_jffs2_script,%,$@)
	@echo sf probe 0 >> $(SCRIPTDIR)/[[$(patsubst %_nor_jffs2_script,%,$@)
	@echo tftp $(TFTPDOWNLOADADDR) $(patsubst %_nor_jffs2_script,%,$@).jffs2 >> $(SCRIPTDIR)/[[$(patsubst %_nor_jffs2_script,%,$@)
	@echo sf erase \$${sf_part_start} \$${sf_part_size} >> $(SCRIPTDIR)/[[$(patsubst %_nor_jffs2_script,%,$@)
	@echo sf write $(TFTPDOWNLOADADDR) \$${sf_part_start} \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_nor_jffs2_script,%,$@)
	@echo  "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[$(patsubst %_nor_jffs2_script,%,$@)

spi_nor_config_script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/set_config
	@echo setenv bootargs console=ttyS0,115200 $(rootfs$(BOOTENV)) $(kernel$(BOOTENV)) $(EXBOOTARGS) >> $(SCRIPTDIR)/set_config
	@echo setenv autoestart 0 >> $(SCRIPTDIR)/set_config
	@echo saveenv >> $(SCRIPTDIR)/set_config
	@echo saveenv >> $(SCRIPTDIR)/set_config
	@echo reset >> $(SCRIPTDIR)/set_config
	@echo  "% <- this is end of file symbol" >> $(SCRIPTDIR)/set_config

emmc_init_script:
	@echo "# <- this is for comment / create emmc partition" > $(SCRIPTDIR)/init_emmc
	@echo emmc erase >>  $(SCRIPTDIR)/init_emmc
	@echo -e $(foreach n,$(USER_PART_LIST),emmc create $(n) $($(n)SIZE)\\n) >> $(SCRIPTDIR)/init_emmc
	@echo "% <- this is end of file symbol" >> $(SCRIPTDIR)/init_emmc

kernel_emmc__script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/[[$(patsubst %_emmc__script,%,$@)
	if [ $(SYSTEM) != "" ]; then \
		echo emmc erase.p $(KERNEL_A_PAT_NAME) >> $(SCRIPTDIR)/[[$(patsubst %_emmc__script,%,$@); \
		echo tftp $(TFTPDOWNLOADADDR) $(patsubst %_emmc__script,%,$@) >> $(SCRIPTDIR)/[[$(patsubst %_emmc__script,%,$@); \
		echo emmc write.p $(TFTPDOWNLOADADDR) $(KERNEL_A_PAT_NAME) \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_emmc__script,%,$@); \
		if [ $(SYSTEM) == "double" ]; then \
			echo emmc erase.p $(KERNEL_B_PAT_NAME) >> $(SCRIPTDIR)/[[$(patsubst %_emmc__script,%,$@); \
			echo emmc write.p $(TFTPDOWNLOADADDR) $(KERNEL_B_PAT_NAME) \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_emmc__script,%,$@); \
			echo mmc erase $(RECOVERY_KERNEL_OFFSET) $(RECOVERY_KERNEL_SIZE) >> $(SCRIPTDIR)/[[$(patsubst %_emmc__script,%,$@); \
			echo mmc write $(TFTPDOWNLOADADDR) $(RECOVERY_KERNEL_OFFSET) \$${filesize} >> $(SCRIPTDIR)/[[$(patsubst %_emmc__script,%,$@); \
		fi; \
	else \
		echo tftp $(TFTPDOWNLOADADDR) $(patsubst %_emmc__script,%,$@) >> $(SCRIPTDIR)/[[$(patsubst %_emmc__script,%,$@); \
		echo mmc write $(TFTPDOWNLOADADDR) 0x800 0x1800 >> $(SCRIPTDIR)/[[$(patsubst %_emmc__script,%,$@); \
		echo mmc dev 0 1 >> $(SCRIPTDIR)/[[$(patsubst %_emmc__script,%,$@); \
		echo setenv bootcmd \' mmc read 0x21000000 0x800 0x1800 \; bootm 0x21000000\; >> $(SCRIPTDIR)/[[$(patsubst %_emmc__script,%,$@); \
	fi;
	@echo "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[$(patsubst %_emmc__script,%,$@)

%_emmc_ext4_script:
	@echo "# <- this is for comment /" > $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@)
	@IMAGE_SIZE="`stat --format=%s $(IMAGEDIR)/$(patsubst %_emmc_ext4_script,%,$@).ext4`"; \
	IMAGE_SIZE_16="0x`echo "obase=16;$$IMAGE_SIZE"|bc`"; \
	IMAGE_BLK_SIZE=$$(($$IMAGE_SIZE/512 + 1)); \
	IMAGE_BLK_SIZE_16="0x`echo "obase=16;$$IMAGE_BLK_SIZE"|bc`"; \
	if [ $$IMAGE_SIZE -gt $(SPLIT_EACH_FILE_SIZE) ]; then \
		split -b $(SPLIT_EACH_FILE_SIZE) $(IMAGEDIR)/$(patsubst %_emmc_ext4_script,%,$@).ext4 $(IMAGEDIR)/$(patsubst %_emmc_ext4_script,%,$@).ext4_; \
		if [ $(patsubst %_emmc_ext4_script,%,$@) = miservice ]; then \
			echo emmc erase.p $(USER_A_PAT_NAME) >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
			if [ $(SYSTEM) == "double" ]; then \
				echo emmc erase.p $(USER_B_PAT_NAME) >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
				echo mmc erase $(RECOVERY_USER_OFFSET) $(RECOVERY_USER_SIZE) >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
				offset_rec=`printf %d $(RECOVERY_USER_OFFSET)`; \
			fi; \
		elif [ $(patsubst %_emmc_ext4_script,%,$@) = customer ]; then \
			echo emmc erase.p $(DATA_PAT_NAME) >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
		else \
			echo emmc erase.p $(ROOTFS_A_PAT_NAME) >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
			if [ $(SYSTEM) == "double" ]; then \
				echo emmc erase.p $(ROOTFS_B_PAT_NAME) >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
				echo mmc erase $(RECOVERY_ROOTFS_OFFSET) $(RECOVERY_ROOTFS_SIZE) >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
				offset_rec=`printf %d $(RECOVERY_ROOTFS_OFFSET)`; \
			fi; \
		fi; \
		offset_blk=0; \
		SPLIT_IMAGE_SIZE_16="0x`echo "obase=16;$(SPLIT_EACH_FILE_SIZE)"|bc`"; \
		SPLIT_IMAGE_BLK_SIZE=$$(($(SPLIT_EACH_FILE_SIZE)/512)); \
		SPLIT_IMAGE_BLK_SIZE_16="0x`echo "obase=16;$$SPLIT_IMAGE_BLK_SIZE"|bc`"; \
		for i in `ls $(IMAGEDIR)/|grep $(patsubst %_emmc_ext4_script,%,$@).ext4_`; do \
			offset_blk_16=0x`echo "obase=16;$$offset_blk"|bc`; \
			if [ $(SYSTEM) == "double" ]; then \
				offset_rec_16=0x`echo "obase=16;$$offset_rec"|bc`; \
			fi; \
			echo tftp $(TFTPDOWNLOADADDR) $$i >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
			if [ $(patsubst %_emmc_ext4_script,%,$@) = miservice ]; then \
				echo emmc write.p.continue $(TFTPDOWNLOADADDR) $(USER_A_PAT_NAME) $$offset_blk_16 $$SPLIT_IMAGE_SIZE_16 >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
				if [ $(SYSTEM) == "double" ]; then \
					echo emmc write.p.continue $(TFTPDOWNLOADADDR) $(USER_B_PAT_NAME) $$offset_blk_16 $$SPLIT_IMAGE_SIZE_16 >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
					echo mmc write $(TFTPDOWNLOADADDR) $$offset_rec_16 $$SPLIT_IMAGE_BLK_SIZE_16 >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
				fi; \
			elif [ $(patsubst %_emmc_ext4_script,%,$@) = customer ]; then \
				echo emmc write.p.continue $(TFTPDOWNLOADADDR) $(DATA_PAT_NAME) $$offset_blk_16 $$SPLIT_IMAGE_SIZE_16>> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
			else \
				echo emmc write.p.continue $(TFTPDOWNLOADADDR) $(ROOTFS_A_PAT_NAME) $$offset_blk_16 $$SPLIT_IMAGE_SIZE_16 >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
				if [ $(SYSTEM) == "double" ]; then \
					echo emmc write.p.continue $(TFTPDOWNLOADADDR) $(ROOTFS_B_PAT_NAME) $$offset_blk_16 $$SPLIT_IMAGE_SIZE_16 >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
					echo mmc write $(TFTPDOWNLOADADDR) $$offset_rec_16 $$SPLIT_IMAGE_BLK_SIZE_16 >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
				fi; \
			fi; \
			offset_blk=$$(($$offset_blk + $$SPLIT_IMAGE_BLK_SIZE)); \
			if [ $(SYSTEM) == "double" ]; then \
				offset_rec=$$(($$offset_rec + $$SPLIT_IMAGE_BLK_SIZE)); \
			fi; \
		done; \
	else \
		echo tftp $(TFTPDOWNLOADADDR) $(patsubst %_emmc_ext4_script,%,$@).ext4 >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
		if [ $(patsubst %_emmc_ext4_script,%,$@) = miservice ]; then \
			echo emmc erase.p $(USER_A_PAT_NAME) >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
			echo emmc write.p $(TFTPDOWNLOADADDR) $(USER_A_PAT_NAME) $$IMAGE_SIZE_16 >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
			if [ $(SYSTEM) == "double" ]; then \
				echo emmc erase.p $(USER_B_PAT_NAME) >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
				echo emmc write.p $(TFTPDOWNLOADADDR) $(USER_B_PAT_NAME) $$IMAGE_SIZE_16 >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
				echo mmc erase $(RECOVERY_USER_OFFSET) $(RECOVERY_USER_SIZE) >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
				echo mmc write $(TFTPDOWNLOADADDR) $(RECOVERY_USER_OFFSET) $$IMAGE_BLK_SIZE_16 >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
			fi; \
		elif [ $(patsubst %_emmc_ext4_script,%,$@) = customer ]; then\
			echo emmc erase.p $(DATA_PAT_NAME) >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
			echo emmc write.p $(TFTPDOWNLOADADDR) $(DATA_PAT_NAME) $$IMAGE_SIZE_16 >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
		else \
			echo emmc erase.p $(ROOTFS_A_PAT_NAME) >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
			echo emmc write.p $(TFTPDOWNLOADADDR) $(ROOTFS_A_PAT_NAME) $$IMAGE_SIZE_16 >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
			if [ $(SYSTEM) == "double" ]; then \
				echo emmc erase.p $(ROOTFS_B_PAT_NAME) >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
				echo emmc write.p $(TFTPDOWNLOADADDR) $(ROOTFS_B_PAT_NAME) $$IMAGE_SIZE_16 >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
				echo mmc erase $(RECOVERY_ROOTFS_OFFSET) $(RECOVERY_ROOTFS_SIZE) >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
				echo mmc write $(TFTPDOWNLOADADDR) $(RECOVERY_ROOTFS_OFFSET) $$IMAGE_BLK_SIZE_16 >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@); \
			fi; \
		fi; \
	fi;
	@echo  "% <- this is end of file symbol" >> $(SCRIPTDIR)/[[$(patsubst %_emmc_ext4_script,%,$@)

emmc_config_script:
	@echo "# <- this is for comment / total file size must be less than 4KB" > $(SCRIPTDIR)/set_config
	if [ $(SYSTEM) != "" ]; then \
		KERNEL_IMAGE_SIZE="`stat --format=%s $(IMAGEDIR)/kernel`"; \
		KERNEL_IMAGE_SIZE_16="0x`echo "obase=16;$$KERNEL_IMAGE_SIZE"|bc`"; \
		ROOTFS_IMAGE_SIZE="`stat --format=%s $(IMAGEDIR)/rootfs.ext4`"; \
		ROOTFS_IMAGE_SIZE_16="0x`echo "obase=16;$$ROOTFS_IMAGE_SIZE"|bc`"; \
		USER_IMAGE_SIZE="`stat --format=%s $(IMAGEDIR)/miservice.ext4`"; \
		USER_IMAGE_SIZE_16="0x`echo "obase=16;$$USER_IMAGE_SIZE"|bc`"; \
		echo setenv bootargs \'  $(ROOTFS_A_PAT_BOOTENV) $(KERNEL_A_PAT_BOOTENV) $(EXBOOTARGS) >> $(SCRIPTDIR)/set_config; \
		echo setenv bootcmd \' emmc read.p $(TFTPDOWNLOADADDR) $(KERNEL_A_PAT_NAME) $($(KERNEL_A_PAT_NAME)SIZE) \;bootm $(TFTPDOWNLOADADDR)\; >> $(SCRIPTDIR)/set_config; \
		if [ $(SYSTEM) == "double" ]; then \
			echo setenv bootargsbp \' $(ROOTFS_B_PAT_BOOTENV) $(KERNEL_B_PAT_BOOTENV) $(EXBOOTARGS) >> $(SCRIPTDIR)/set_config; \
			echo setenv bootcmdbp \' emmc read.p $(TFTPDOWNLOADADDR) $(KERNEL_B_PAT_NAME) $($(KERNEL_B_PAT_NAME)SIZE) \;bootm $(TFTPDOWNLOADADDR)\; >> $(SCRIPTDIR)/set_config; \
			#echo setenv reckey \' pin=$(RECOVERY_KEY_PIN),level=$(RECOVERY_KEY_LEVEL) >> $(SCRIPTDIR)/set_config; \
			echo setenv recargs\' kernel=$(RECOVERY_KERNEL_OFFSET),$$KERNEL_IMAGE_SIZE_16,$(KERNEL_A_PAT_NAME),$(KERNEL_B_PAT_NAME)\;rootfs=$(RECOVERY_ROOTFS_OFFSET),$$ROOTFS_IMAGE_SIZE_16,$(ROOTFS_A_PAT_NAME),$(ROOTFS_B_PAT_NAME)\;user=$(RECOVERY_USER_OFFSET),$$USER_IMAGE_SIZE_16,$(USER_A_PAT_NAME),$(USER_B_PAT_NAME) >> $(SCRIPTDIR)/set_config; \
		fi; \
	else \
		echo mmc dev 0 1 >> $(SCRIPTDIR)/set_config; \
		echo mmc bootbus 0 1 0 0 >> $(SCRIPTDIR)/set_config; \
		echo mmc partconf 0 1 1 0 >> $(SCRIPTDIR)/set_config; \
		echo setenv bootargs \' console=ttyS0,115200 root=/dev/mmcblk0boot1 rootwait rootfstype=squashfs ro init=/linuxrc cma=64M >> $(SCRIPTDIR)/set_config; \
	fi;
	@echo saveenv >> $(SCRIPTDIR)/set_config
	@echo  "% <- this is end of file symbol" >> $(SCRIPTDIR)/set_config
