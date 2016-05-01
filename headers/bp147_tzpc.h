// ----------------------------------------------------------
// BP147 TrustZone Controller
// Header file
//
// NOTE: All regions default to SECURE
// ----------------------------------------------------------

#ifndef __BP147_TZPC_h
#define __BP147_TZPC_h

#define BP147_TZPC_REGION_0   (0)
#define BP147_TZPC_REGION_1   (1)
#define BP147_TZPC_REGION_2   (2)

#define BP147_TZPC_BIT_0      (1)
#define BP147_TZPC_BIT_1      (1 << 1)
#define BP147_TZPC_BIT_2      (1 << 2)
#define BP147_TZPC_BIT_3      (1 << 3)
#define BP147_TZPC_BIT_4      (1 << 4)
#define BP147_TZPC_BIT_5      (1 << 5)
#define BP147_TZPC_BIT_6      (1 << 6)
#define BP147_TZPC_BIT_7      (1 << 7)

// Returns the current status of the specified TZPC decode register
unsigned int getDecodeRegion(unsigned int region);

// Sets the specified bits of the specified region to Secure
void setDecodeRegionS(unsigned int region, unsigned int bits);

// Sets the specified bits of the specified region to NS
void setDecodeRegionNS(unsigned int region, unsigned int bits);

#endif

// ------------------------------------------------------------
// End of bp147_tzpc.c
// ------------------------------------------------------------
