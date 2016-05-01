// ----------------------------------------------------------
// BP147 TrustZone Controller
//
// ----------------------------------------------------------

#include "bp147_tzpc.h"

struct bp147_tzpc
{
  volatile unsigned int TZPCR0SIZE;        // +0x0
  
  volatile unsigned int padding[511];      // +0x04--0x7FC
  
  volatile unsigned int TZPCDECPROT0Stat;  // +0x800
  volatile unsigned int TZPCDECPROT0Set;   // +0x804
  volatile unsigned int TZPCDECPROT0Clrl;  // +0x808
  volatile unsigned int TZPCDECPROT1Stat;  // +0x80C
  volatile unsigned int TZPCDECPROT1Set;   // +0x810
  volatile unsigned int TZPCDECPROT1Clrl;  // +0x814
  volatile unsigned int TZPCDECPROT2Stat;  // +0x818
  volatile unsigned int TZPCDECPROT2Set;   // +0x81C
  volatile unsigned int TZPCDECPROT2Clrl;  // +0x820

  // Not including the ID registers

};

// Instance of the TZPC, will be placed using the scatter file
struct bp147_tzpc tzpc;


unsigned int getDecodeRegion(unsigned int region)
{
  switch (region)
  {
    case BP147_TZPC_REGION_0:
      return tzpc.TZPCDECPROT0Stat;

    case BP147_TZPC_REGION_1:
      return tzpc.TZPCDECPROT1Stat;

    case BP147_TZPC_REGION_2:
      return tzpc.TZPCDECPROT2Stat;

    default:
      return 0;
  }
}

void setDecodeRegionS(unsigned int region, unsigned int bits)
{
  bits = bits & 0xFF;
  
  switch (region)
  {
    case BP147_TZPC_REGION_0:
      tzpc.TZPCDECPROT0Clrl = bits;
      break;

    case BP147_TZPC_REGION_1:
      tzpc.TZPCDECPROT1Clrl = bits;
      break;

    case BP147_TZPC_REGION_2:
      tzpc.TZPCDECPROT2Clrl = bits;
      break;

    default:
      break;
  }

  return;
}

void setDecodeRegionNS(unsigned int region, unsigned int bits)
{
  bits = bits & 0xFF;

  switch (region)
  {
    case BP147_TZPC_REGION_0:
      tzpc.TZPCDECPROT0Set = bits;
      break;

    case BP147_TZPC_REGION_1:
      tzpc.TZPCDECPROT1Set = bits;
      break;

    case BP147_TZPC_REGION_2:
      tzpc.TZPCDECPROT2Set = bits;
      break;

    default:
      break;
  }

  return;
  
}


// ------------------------------------------------------------
// End of bp147_tzpc.c
// ------------------------------------------------------------
