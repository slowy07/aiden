kernel_init_storage:
  mov eax, DRIVER_PCI_CLASS_SUBCLASS_ide
  call driver_pci_find_class_and_subclass
  jc .no_ide
  call driver_ide_init

.no_ide:
