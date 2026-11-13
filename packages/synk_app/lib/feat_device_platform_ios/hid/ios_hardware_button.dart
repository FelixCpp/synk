typedef IosHardwareButton = ({int usagePage, int usageCode});

const _consumerPage = 0x0c;
const _consumerSleepWake = 0x30;
const _consumerHome = 0x40;

const IosHardwareButton iosPowerButton = (
  usagePage: _consumerPage,
  usageCode: _consumerSleepWake,
);

const IosHardwareButton iosHomeButton = (
  usagePage: _consumerPage,
  usageCode: _consumerHome,
);
