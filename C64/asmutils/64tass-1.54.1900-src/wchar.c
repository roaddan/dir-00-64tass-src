/*
    $Id: wchar.c 1626 2018-08-31 16:41:21Z soci $

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

*/
#include "wchar.h"

#ifdef __DJGPP__
#include <errno.h>
#include <ctype.h>
#include "wctype.h"
#include "attributes.h"
#include <dpmi.h>
#include <go32.h>

static const wchar_t *cp;
static uint32_t revcp[128];

static const wchar_t cp437[128] = {
    0x00c7, 0x00fc, 0x00e9, 0x00e2, 0x00e4, 0x00e0, 0x00e5, 0x00e7, 0x00ea,
    0x00eb, 0x00e8, 0x00ef, 0x00ee, 0x00ec, 0x00c4, 0x00c5, 0x00c9, 0x00e6,
    0x00c6, 0x00f4, 0x00f6, 0x00f2, 0x00fb, 0x00f9, 0x00ff, 0x00d6, 0x00dc,
    0x00a2, 0x00a3, 0x00a5, 0x20a7, 0x0192, 0x00e1, 0x00ed, 0x00f3, 0x00fa,
    0x00f1, 0x00d1, 0x00aa, 0x00ba, 0x00bf, 0x2310, 0x00ac, 0x00bd, 0x00bc,
    0x00a1, 0x00ab, 0x00bb, 0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x2561,
    0x2562, 0x2556, 0x2555, 0x2563, 0x2551, 0x2557, 0x255d, 0x255c, 0x255b,
    0x2510, 0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x255e, 0x255f,
    0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x2567, 0x2568,
    0x2564, 0x2565, 0x2559, 0x2558, 0x2552, 0x2553, 0x256b, 0x256a, 0x2518,
    0x250c, 0x2588, 0x2584, 0x258c, 0x2590, 0x2580, 0x03b1, 0x00df, 0x0393,
    0x03c0, 0x03a3, 0x03c3, 0x00b5, 0x03c4, 0x03a6, 0x0398, 0x03a9, 0x03b4,
    0x221e, 0x03c6, 0x03b5, 0x2229, 0x2261, 0x00b1, 0x2265, 0x2264, 0x2320,
    0x2321, 0x00f7, 0x2248, 0x00b0, 0x2219, 0x00b7, 0x221a, 0x207f, 0x00b2,
    0x25a0, 0x00a0
};

static const wchar_t cp737[128] = {
    0x0391, 0x0392, 0x0393, 0x0394, 0x0395, 0x0396, 0x0397, 0x0398, 0x0399,
    0x039a, 0x039b, 0x039c, 0x039d, 0x039e, 0x039f, 0x03a0, 0x03a1, 0x03a3,
    0x03a4, 0x03a5, 0x03a6, 0x03a7, 0x03a8, 0x03a9, 0x03b1, 0x03b2, 0x03b3,
    0x03b4, 0x03b5, 0x03b6, 0x03b7, 0x03b8, 0x03b9, 0x03ba, 0x03bb, 0x03bc,
    0x03bd, 0x03be, 0x03bf, 0x03c0, 0x03c1, 0x03c3, 0x03c2, 0x03c4, 0x03c5,
    0x03c6, 0x03c7, 0x03c8, 0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x2561,
    0x2562, 0x2556, 0x2555, 0x2563, 0x2551, 0x2557, 0x255d, 0x255c, 0x255b,
    0x2510, 0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x255e, 0x255f,
    0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x2567, 0x2568,
    0x2564, 0x2565, 0x2559, 0x2558, 0x2552, 0x2553, 0x256b, 0x256a, 0x2518,
    0x250c, 0x2588, 0x2584, 0x258c, 0x2590, 0x2580, 0x03c9, 0x03ac, 0x03ad,
    0x03ae, 0x03ca, 0x03af, 0x03cc, 0x03cd, 0x03cb, 0x03ce, 0x0386, 0x0388,
    0x0389, 0x038a, 0x038c, 0x038e, 0x038f, 0x00b1, 0x2265, 0x2264, 0x03aa,
    0x03ab, 0x00f7, 0x2248, 0x00b0, 0x2219, 0x00b7, 0x221a, 0x207f, 0x00b2,
    0x25a0, 0x00a0
};

static const wchar_t cp775[128] = {
    0x0106, 0x00fc, 0x00e9, 0x0101, 0x00e4, 0x0123, 0x00e5, 0x0107, 0x0142,
    0x0113, 0x0156, 0x0157, 0x012b, 0x0179, 0x00c4, 0x00c5, 0x00c9, 0x00e6,
    0x00c6, 0x014d, 0x00f6, 0x0122, 0x00a2, 0x015a, 0x015b, 0x00d6, 0x00dc,
    0x00f8, 0x00a3, 0x00d8, 0x00d7, 0x00a4, 0x0100, 0x012a, 0x00f3, 0x017b,
    0x017c, 0x017a, 0x201d, 0x00a6, 0x00a9, 0x00ae, 0x00ac, 0x00bd, 0x00bc,
    0x0141, 0x00ab, 0x00bb, 0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x0104,
    0x010c, 0x0118, 0x0116, 0x2563, 0x2551, 0x2557, 0x255d, 0x012e, 0x0160,
    0x2510, 0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x0172, 0x016a,
    0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x017d, 0x0105,
    0x010d, 0x0119, 0x0117, 0x012f, 0x0161, 0x0173, 0x016b, 0x017e, 0x2518,
    0x250c, 0x2588, 0x2584, 0x258c, 0x2590, 0x2580, 0x00d3, 0x00df, 0x014c,
    0x0143, 0x00f5, 0x00d5, 0x00b5, 0x0144, 0x0136, 0x0137, 0x013b, 0x013c,
    0x0146, 0x0112, 0x0145, 0x2019, 0x00ad, 0x00b1, 0x201c, 0x00be, 0x00b6,
    0x00a7, 0x00f7, 0x201e, 0x00b0, 0x2219, 0x00b7, 0x00b9, 0x00b3, 0x00b2,
    0x25a0, 0x00a0
};

static const wchar_t cp850[128] = {
    0x00c7, 0x00fc, 0x00e9, 0x00e2, 0x00e4, 0x00e0, 0x00e5, 0x00e7, 0x00ea,
    0x00eb, 0x00e8, 0x00ef, 0x00ee, 0x00ec, 0x00c4, 0x00c5, 0x00c9, 0x00e6,
    0x00c6, 0x00f4, 0x00f6, 0x00f2, 0x00fb, 0x00f9, 0x00ff, 0x00d6, 0x00dc,
    0x00f8, 0x00a3, 0x00d8, 0x00d7, 0x0192, 0x00e1, 0x00ed, 0x00f3, 0x00fa,
    0x00f1, 0x00d1, 0x00aa, 0x00ba, 0x00bf, 0x00ae, 0x00ac, 0x00bd, 0x00bc,
    0x00a1, 0x00ab, 0x00bb, 0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x00c1,
    0x00c2, 0x00c0, 0x00a9, 0x2563, 0x2551, 0x2557, 0x255d, 0x00a2, 0x00a5,
    0x2510, 0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x00e3, 0x00c3,
    0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x00a4, 0x00f0,
    0x00d0, 0x00ca, 0x00cb, 0x00c8, 0x0131, 0x00cd, 0x00ce, 0x00cf, 0x2518,
    0x250c, 0x2588, 0x2584, 0x00a6, 0x00cc, 0x2580, 0x00d3, 0x00df, 0x00d4,
    0x00d2, 0x00f5, 0x00d5, 0x00b5, 0x00fe, 0x00de, 0x00da, 0x00db, 0x00d9,
    0x00fd, 0x00dd, 0x00af, 0x00b4, 0x00ad, 0x00b1, 0x2017, 0x00be, 0x00b6,
    0x00a7, 0x00f7, 0x00b8, 0x00b0, 0x00a8, 0x00b7, 0x00b9, 0x00b3, 0x00b2,
    0x25a0, 0x00a0
};

static const wchar_t cp852[128] = {
    0x00c7, 0x00fc, 0x00e9, 0x00e2, 0x00e4, 0x016f, 0x0107, 0x00e7, 0x0142,
    0x00eb, 0x0150, 0x0151, 0x00ee, 0x0179, 0x00c4, 0x0106, 0x00c9, 0x0139,
    0x013a, 0x00f4, 0x00f6, 0x013d, 0x013e, 0x015a, 0x015b, 0x00d6, 0x00dc,
    0x0164, 0x0165, 0x0141, 0x00d7, 0x010d, 0x00e1, 0x00ed, 0x00f3, 0x00fa,
    0x0104, 0x0105, 0x017d, 0x017e, 0x0118, 0x0119, 0x00ac, 0x017a, 0x010c,
    0x015f, 0x00ab, 0x00bb, 0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x00c1,
    0x00c2, 0x011a, 0x015e, 0x2563, 0x2551, 0x2557, 0x255d, 0x017b, 0x017c,
    0x2510, 0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x0102, 0x0103,
    0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x00a4, 0x0111,
    0x0110, 0x010e, 0x00cb, 0x010f, 0x0147, 0x00cd, 0x00ce, 0x011b, 0x2518,
    0x250c, 0x2588, 0x2584, 0x0162, 0x016e, 0x2580, 0x00d3, 0x00df, 0x00d4,
    0x0143, 0x0144, 0x0148, 0x0160, 0x0161, 0x0154, 0x00da, 0x0155, 0x0170,
    0x00fd, 0x00dd, 0x0163, 0x00b4, 0x00ad, 0x02dd, 0x02db, 0x02c7, 0x02d8,
    0x00a7, 0x00f7, 0x00b8, 0x00b0, 0x00a8, 0x02d9, 0x0171, 0x0158, 0x0159,
    0x25a0, 0x00a0
};

static const wchar_t cp855[128] = {
    0x0452, 0x0402, 0x0453, 0x0403, 0x0451, 0x0401, 0x0454, 0x0404, 0x0455,
    0x0405, 0x0456, 0x0406, 0x0457, 0x0407, 0x0458, 0x0408, 0x0459, 0x0409,
    0x045a, 0x040a, 0x045b, 0x040b, 0x045c, 0x040c, 0x045e, 0x040e, 0x045f,
    0x040f, 0x044e, 0x042e, 0x044a, 0x042a, 0x0430, 0x0410, 0x0431, 0x0411,
    0x0446, 0x0426, 0x0434, 0x0414, 0x0435, 0x0415, 0x0444, 0x0424, 0x0433,
    0x0413, 0x00ab, 0x00bb, 0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x0445,
    0x0425, 0x0438, 0x0418, 0x2563, 0x2551, 0x2557, 0x255d, 0x0439, 0x0419,
    0x2510, 0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x043a, 0x041a,
    0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x00a4, 0x043b,
    0x041b, 0x043c, 0x041c, 0x043d, 0x041d, 0x043e, 0x041e, 0x043f, 0x2518,
    0x250c, 0x2588, 0x2584, 0x041f, 0x044f, 0x2580, 0x042f, 0x0440, 0x0420,
    0x0441, 0x0421, 0x0442, 0x0422, 0x0443, 0x0423, 0x0436, 0x0416, 0x0432,
    0x0412, 0x044c, 0x042c, 0x2116, 0x00ad, 0x044b, 0x042b, 0x0437, 0x0417,
    0x0448, 0x0428, 0x044d, 0x042d, 0x0449, 0x0429, 0x0447, 0x0427, 0x00a7,
    0x25a0, 0x00a0
};

static const wchar_t cp857[128] = {
    0x00c7, 0x00fc, 0x00e9, 0x00e2, 0x00e4, 0x00e0, 0x00e5, 0x00e7, 0x00ea,
    0x00eb, 0x00e8, 0x00ef, 0x00ee, 0x0131, 0x00c4, 0x00c5, 0x00c9, 0x00e6,
    0x00c6, 0x00f4, 0x00f6, 0x00f2, 0x00fb, 0x00f9, 0x0130, 0x00d6, 0x00dc,
    0x00f8, 0x00a3, 0x00d8, 0x015e, 0x015f, 0x00e1, 0x00ed, 0x00f3, 0x00fa,
    0x00f1, 0x00d1, 0x011e, 0x011f, 0x00bf, 0x00ae, 0x00ac, 0x00bd, 0x00bc,
    0x00a1, 0x00ab, 0x00bb, 0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x00c1,
    0x00c2, 0x00c0, 0x00a9, 0x2563, 0x2551, 0x2557, 0x255d, 0x00a2, 0x00a5,
    0x2510, 0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x00e3, 0x00c3,
    0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x00a4, 0x00ba,
    0x00aa, 0x00ca, 0x00cb, 0x00c8, 0x20ac, 0x00cd, 0x00ce, 0x00cf, 0x2518,
    0x250c, 0x2588, 0x2584, 0x00a6, 0x00cc, 0x2580, 0x00d3, 0x00df, 0x00d4,
    0x00d2, 0x00f5, 0x00d5, 0x00b5,      0, 0x00d7, 0x00da, 0x00db, 0x00d9,
    0x00ec, 0x00ff, 0x00af, 0x00b4, 0x00ad, 0x00b1,      0, 0x00be, 0x00b6,
    0x00a7, 0x00f7, 0x00b8, 0x00b0, 0x00a8, 0x00b7, 0x00b9, 0x00b3, 0x00b2,
    0x25a0, 0x00a0
};

static const wchar_t cp860[128] = {
    0x00c7, 0x00fc, 0x00e9, 0x00e2, 0x00e3, 0x00e0, 0x00c1, 0x00e7, 0x00ea,
    0x00ca, 0x00e8, 0x00cd, 0x00d4, 0x00ec, 0x00c3, 0x00c2, 0x00c9, 0x00c0,
    0x00c8, 0x00f4, 0x00f5, 0x00f2, 0x00da, 0x00f9, 0x00cc, 0x00d5, 0x00dc,
    0x00a2, 0x00a3, 0x00d9, 0x20a7, 0x00d3, 0x00e1, 0x00ed, 0x00f3, 0x00fa,
    0x00f1, 0x00d1, 0x00aa, 0x00ba, 0x00bf, 0x00d2, 0x00ac, 0x00bd, 0x00bc,
    0x00a1, 0x00ab, 0x00bb, 0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x2561,
    0x2562, 0x2556, 0x2555, 0x2563, 0x2551, 0x2557, 0x255d, 0x255c, 0x255b,
    0x2510, 0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x255e, 0x255f,
    0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x2567, 0x2568,
    0x2564, 0x2565, 0x2559, 0x2558, 0x2552, 0x2553, 0x256b, 0x256a, 0x2518,
    0x250c, 0x2588, 0x2584, 0x258c, 0x2590, 0x2580, 0x03b1, 0x00df, 0x0393,
    0x03c0, 0x03a3, 0x03c3, 0x00b5, 0x03c4, 0x03a6, 0x0398, 0x03a9, 0x03b4,
    0x221e, 0x03c6, 0x03b5, 0x2229, 0x2261, 0x00b1, 0x2265, 0x2264, 0x2320,
    0x2321, 0x00f7, 0x2248, 0x00b0, 0x2219, 0x00b7, 0x221a, 0x207f, 0x00b2,
    0x25a0, 0x00a0
};

static const wchar_t cp861[128] = {
    0x00c7, 0x00fc, 0x00e9, 0x00e2, 0x00e4, 0x00e0, 0x00e5, 0x00e7, 0x00ea,
    0x00eb, 0x00e8, 0x00d0, 0x00f0, 0x00de, 0x00c4, 0x00c5, 0x00c9, 0x00e6,
    0x00c6, 0x00f4, 0x00f6, 0x00fe, 0x00fb, 0x00dd, 0x00fd, 0x00d6, 0x00dc,
    0x00f8, 0x00a3, 0x00d8, 0x20a7, 0x0192, 0x00e1, 0x00ed, 0x00f3, 0x00fa,
    0x00c1, 0x00cd, 0x00d3, 0x00da, 0x00bf, 0x2310, 0x00ac, 0x00bd, 0x00bc,
    0x00a1, 0x00ab, 0x00bb, 0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x2561,
    0x2562, 0x2556, 0x2555, 0x2563, 0x2551, 0x2557, 0x255d, 0x255c, 0x255b,
    0x2510, 0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x255e, 0x255f,
    0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x2567, 0x2568,
    0x2564, 0x2565, 0x2559, 0x2558, 0x2552, 0x2553, 0x256b, 0x256a, 0x2518,
    0x250c, 0x2588, 0x2584, 0x258c, 0x2590, 0x2580, 0x03b1, 0x00df, 0x0393,
    0x03c0, 0x03a3, 0x03c3, 0x00b5, 0x03c4, 0x03a6, 0x0398, 0x03a9, 0x03b4,
    0x221e, 0x03c6, 0x03b5, 0x2229, 0x2261, 0x00b1, 0x2265, 0x2264, 0x2320,
    0x2321, 0x00f7, 0x2248, 0x00b0, 0x2219, 0x00b7, 0x221a, 0x207f, 0x00b2,
    0x25a0, 0x00a0
};

static const wchar_t cp862[128] = {
    0x05d0, 0x05d1, 0x05d2, 0x05d3, 0x05d4, 0x05d5, 0x05d6, 0x05d7, 0x05d8,
    0x05d9, 0x05da, 0x05db, 0x05dc, 0x05dd, 0x05de, 0x05df, 0x05e0, 0x05e1,
    0x05e2, 0x05e3, 0x05e4, 0x05e5, 0x05e6, 0x05e7, 0x05e8, 0x05e9, 0x05ea,
    0x00a2, 0x00a3, 0x00a5, 0x20a7, 0x0192, 0x00e1, 0x00ed, 0x00f3, 0x00fa,
    0x00f1, 0x00d1, 0x00aa, 0x00ba, 0x00bf, 0x2310, 0x00ac, 0x00bd, 0x00bc,
    0x00a1, 0x00ab, 0x00bb, 0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x2561,
    0x2562, 0x2556, 0x2555, 0x2563, 0x2551, 0x2557, 0x255d, 0x255c, 0x255b,
    0x2510, 0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x255e, 0x255f,
    0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x2567, 0x2568,
    0x2564, 0x2565, 0x2559, 0x2558, 0x2552, 0x2553, 0x256b, 0x256a, 0x2518,
    0x250c, 0x2588, 0x2584, 0x258c, 0x2590, 0x2580, 0x03b1, 0x00df, 0x0393,
    0x03c0, 0x03a3, 0x03c3, 0x00b5, 0x03c4, 0x03a6, 0x0398, 0x03a9, 0x03b4,
    0x221e, 0x03c6, 0x03b5, 0x2229, 0x2261, 0x00b1, 0x2265, 0x2264, 0x2320,
    0x2321, 0x00f7, 0x2248, 0x00b0, 0x2219, 0x00b7, 0x221a, 0x207f, 0x00b2,
    0x25a0, 0x00a0
};

static const wchar_t cp863[128] = {
    0x00c7, 0x00fc, 0x00e9, 0x00e2, 0x00c2, 0x00e0, 0x00b6, 0x00e7, 0x00ea,
    0x00eb, 0x00e8, 0x00ef, 0x00ee, 0x2017, 0x00c0, 0x00a7, 0x00c9, 0x00c8,
    0x00ca, 0x00f4, 0x00cb, 0x00cf, 0x00fb, 0x00f9, 0x00a4, 0x00d4, 0x00dc,
    0x00a2, 0x00a3, 0x00d9, 0x00db, 0x0192, 0x00a6, 0x00b4, 0x00f3, 0x00fa,
    0x00a8, 0x00b8, 0x00b3, 0x00af, 0x00ce, 0x2310, 0x00ac, 0x00bd, 0x00bc,
    0x00be, 0x00ab, 0x00bb, 0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x2561,
    0x2562, 0x2556, 0x2555, 0x2563, 0x2551, 0x2557, 0x255d, 0x255c, 0x255b,
    0x2510, 0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x255e, 0x255f,
    0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x2567, 0x2568,
    0x2564, 0x2565, 0x2559, 0x2558, 0x2552, 0x2553, 0x256b, 0x256a, 0x2518,
    0x250c, 0x2588, 0x2584, 0x258c, 0x2590, 0x2580, 0x03b1, 0x00df, 0x0393,
    0x03c0, 0x03a3, 0x03c3, 0x00b5, 0x03c4, 0x03a6, 0x0398, 0x03a9, 0x03b4,
    0x221e, 0x03c6, 0x03b5, 0x2229, 0x2261, 0x00b1, 0x2265, 0x2264, 0x2320,
    0x2321, 0x00f7, 0x2248, 0x00b0, 0x2219, 0x00b7, 0x221a, 0x207f, 0x00b2,
    0x25a0, 0x00a0
};

static const wchar_t cp864[128] = {
    0x00b0, 0x00b7, 0x2219, 0x221a, 0x2592, 0x2500, 0x2502, 0x253c, 0x2524,
    0x252c, 0x251c, 0x2534, 0x2510, 0x250c, 0x2514, 0x2518, 0x03b2, 0x221e,
    0x03c6, 0x00b1, 0x00bd, 0x00bc, 0x2248, 0x00ab, 0x00bb, 0xfef7, 0xfef8,
         0,      0, 0xfefb, 0xfefc,      0, 0x00a0, 0x00ad, 0xfe82, 0x00a3,
    0x00a4, 0xfe84,      0,      0, 0xfe8e, 0xfe8f, 0xfe95, 0xfe99, 0x060c,
    0xfe9d, 0xfea1, 0xfea5, 0x0660, 0x0661, 0x0662, 0x0663, 0x0664, 0x0665,
    0x0666, 0x0667, 0x0668, 0x0669, 0xfed1, 0x061b, 0xfeb1, 0xfeb5, 0xfeb9,
    0x061f, 0x00a2, 0xfe80, 0xfe81, 0xfe83, 0xfe85, 0xfeca, 0xfe8b, 0xfe8d,
    0xfe91, 0xfe93, 0xfe97, 0xfe9b, 0xfe9f, 0xfea3, 0xfea7, 0xfea9, 0xfeab,
    0xfead, 0xfeaf, 0xfeb3, 0xfeb7, 0xfebb, 0xfebf, 0xfec1, 0xfec5, 0xfecb,
    0xfecf, 0x00a6, 0x00ac, 0x00f7, 0x00d7, 0xfec9, 0x0640, 0xfed3, 0xfed7,
    0xfedb, 0xfedf, 0xfee3, 0xfee7, 0xfeeb, 0xfeed, 0xfeef, 0xfef3, 0xfebd,
    0xfecc, 0xfece, 0xfecd, 0xfee1, 0xfe7d, 0x0651, 0xfee5, 0xfee9, 0xfeec,
    0xfef0, 0xfef2, 0xfed0, 0xfed5, 0xfef5, 0xfef6, 0xfedd, 0xfed9, 0xfef1,
    0x25a0, 0x20
};

static const wchar_t cp865[128] = {
    0x00c7, 0x00fc, 0x00e9, 0x00e2, 0x00e4, 0x00e0, 0x00e5, 0x00e7, 0x00ea,
    0x00eb, 0x00e8, 0x00ef, 0x00ee, 0x00ec, 0x00c4, 0x00c5, 0x00c9, 0x00e6,
    0x00c6, 0x00f4, 0x00f6, 0x00f2, 0x00fb, 0x00f9, 0x00ff, 0x00d6, 0x00dc,
    0x00f8, 0x00a3, 0x00d8, 0x20a7, 0x0192, 0x00e1, 0x00ed, 0x00f3, 0x00fa,
    0x00f1, 0x00d1, 0x00aa, 0x00ba, 0x00bf, 0x2310, 0x00ac, 0x00bd, 0x00bc,
    0x00a1, 0x00ab, 0x00a4, 0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x2561,
    0x2562, 0x2556, 0x2555, 0x2563, 0x2551, 0x2557, 0x255d, 0x255c, 0x255b,
    0x2510, 0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x255e, 0x255f,
    0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x2567, 0x2568,
    0x2564, 0x2565, 0x2559, 0x2558, 0x2552, 0x2553, 0x256b, 0x256a, 0x2518,
    0x250c, 0x2588, 0x2584, 0x258c, 0x2590, 0x2580, 0x03b1, 0x00df, 0x0393,
    0x03c0, 0x03a3, 0x03c3, 0x00b5, 0x03c4, 0x03a6, 0x0398, 0x03a9, 0x03b4,
    0x221e, 0x03c6, 0x03b5, 0x2229, 0x2261, 0x00b1, 0x2265, 0x2264, 0x2320,
    0x2321, 0x00f7, 0x2248, 0x00b0, 0x2219, 0x00b7, 0x221a, 0x207f, 0x00b2,
    0x25a0, 0x00a0
};

static const wchar_t cp866[128] = {
    0x0410, 0x0411, 0x0412, 0x0413, 0x0414, 0x0415, 0x0416, 0x0417, 0x0418,
    0x0419, 0x041a, 0x041b, 0x041c, 0x041d, 0x041e, 0x041f, 0x0420, 0x0421,
    0x0422, 0x0423, 0x0424, 0x0425, 0x0426, 0x0427, 0x0428, 0x0429, 0x042a,
    0x042b, 0x042c, 0x042d, 0x042e, 0x042f, 0x0430, 0x0431, 0x0432, 0x0433,
    0x0434, 0x0435, 0x0436, 0x0437, 0x0438, 0x0439, 0x043a, 0x043b, 0x043c,
    0x043d, 0x043e, 0x043f, 0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x2561,
    0x2562, 0x2556, 0x2555, 0x2563, 0x2551, 0x2557, 0x255d, 0x255c, 0x255b,
    0x2510, 0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x255e, 0x255f,
    0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x2567, 0x2568,
    0x2564, 0x2565, 0x2559, 0x2558, 0x2552, 0x2553, 0x256b, 0x256a, 0x2518,
    0x250c, 0x2588, 0x2584, 0x258c, 0x2590, 0x2580, 0x0440, 0x0441, 0x0442,
    0x0443, 0x0444, 0x0445, 0x0446, 0x0447, 0x0448, 0x0449, 0x044a, 0x044b,
    0x044c, 0x044d, 0x044e, 0x044f, 0x0401, 0x0451, 0x0404, 0x0454, 0x0407,
    0x0457, 0x040e, 0x045e, 0x00b0, 0x2219, 0x00b7, 0x221a, 0x2116, 0x00a4,
    0x25a0, 0x00a0
};

static const wchar_t cp869[128] = {
         0,      0,      0,      0,      0,      0, 0x0386,      0, 0x00b7,
    0x00ac, 0x00a6, 0x2018, 0x2019, 0x0388, 0x2015, 0x0389, 0x038a, 0x03aa,
    0x038c,      0,      0, 0x038e, 0x03ab, 0x00a9, 0x038f, 0x00b2, 0x00b3,
    0x03ac, 0x00a3, 0x03ad, 0x03ae, 0x03af, 0x03ca, 0x0390, 0x03cc, 0x03cd,
    0x0391, 0x0392, 0x0393, 0x0394, 0x0395, 0x0396, 0x0397, 0x00bd, 0x0398,
    0x0399, 0x00ab, 0x00bb, 0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x039a,
    0x039b, 0x039c, 0x039d, 0x2563, 0x2551, 0x2557, 0x255d, 0x039e, 0x039f,
    0x2510, 0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x03a0, 0x03a1,
    0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x03a3, 0x03a4,
    0x03a5, 0x03a6, 0x03a7, 0x03a8, 0x03a9, 0x03b1, 0x03b2, 0x03b3, 0x2518,
    0x250c, 0x2588, 0x2584, 0x03b4, 0x03b5, 0x2580, 0x03b6, 0x03b7, 0x03b8,
    0x03b9, 0x03ba, 0x03bb, 0x03bc, 0x03bd, 0x03be, 0x03bf, 0x03c0, 0x03c1,
    0x03c3, 0x03c2, 0x03c4, 0x0384, 0x00ad, 0x00b1, 0x03c5, 0x03c6, 0x03c7,
    0x00a7, 0x03c8, 0x0385, 0x00b0, 0x00a8, 0x03c9, 0x03cb, 0x03b0, 0x03ce,
    0x25a0, 0x00a0
};

static const wchar_t cp874[128] = {
    0x20ac,      0,      0,      0,      0, 0x2026,      0,      0,      0,
         0,      0,      0,      0,      0,      0,      0,      0, 0x2018,
    0x2019, 0x201c, 0x201d, 0x2022, 0x2013, 0x2014,      0,      0,      0,
         0,      0,      0,      0,      0, 0x00a0, 0x0e01, 0x0e02, 0x0e03,
    0x0e04, 0x0e05, 0x0e06, 0x0e07, 0x0e08, 0x0e09, 0x0e0a, 0x0e0b, 0x0e0c,
    0x0e0d, 0x0e0e, 0x0e0f, 0x0e10, 0x0e11, 0x0e12, 0x0e13, 0x0e14, 0x0e15,
    0x0e16, 0x0e17, 0x0e18, 0x0e19, 0x0e1a, 0x0e1b, 0x0e1c, 0x0e1d, 0x0e1e,
    0x0e1f, 0x0e20, 0x0e21, 0x0e22, 0x0e23, 0x0e24, 0x0e25, 0x0e26, 0x0e27,
    0x0e28, 0x0e29, 0x0e2a, 0x0e2b, 0x0e2c, 0x0e2d, 0x0e2e, 0x0e2f, 0x0e30,
    0x0e31, 0x0e32, 0x0e33, 0x0e34, 0x0e35, 0x0e36, 0x0e37, 0x0e38, 0x0e39,
    0x0e3a,      0,      0,      0,      0, 0x0e3f, 0x0e40, 0x0e41, 0x0e42,
    0x0e43, 0x0e44, 0x0e45, 0x0e46, 0x0e47, 0x0e48, 0x0e49, 0x0e4a, 0x0e4b,
    0x0e4c, 0x0e4d, 0x0e4e, 0x0e4f, 0x0e50, 0x0e51, 0x0e52, 0x0e53, 0x0e54,
    0x0e55, 0x0e56, 0x0e57, 0x0e58, 0x0e59, 0x0e5a, 0x0e5b,      0,      0,
         0, 0x20
};

static int compcp(const void *a, const void *b) {
    return *(uint32_t *)a - *(uint32_t *)b;
}

static int compcp2(const void *a, const void *b) {
    return (*(uint32_t *)a & ~0xff) - (*(uint32_t *)b & ~0xff);
}

static void set_cp(void) {
    uint16_t dcp;
    int i;
    __dpmi_regs regs;
    regs.x.ax = 0x440c;
    regs.x.bx = 1;
    regs.x.cx = 0x36a;
    regs.x.ds = __tb >> 4;
    regs.x.dx = __tb & 0xf;
    regs.x.flags |= 1;
    __dpmi_int(0x21, &regs);
    if (regs.x.flags & 1) {
        regs.x.ax = 0xad02;
        regs.x.bx = 0xfffe;
        __dpmi_int(0x2f, &regs);
        dcp = (regs.x.flags & 1) ? 0 : regs.x.bx;
    } else {
        dosmemget(__tb + 2, sizeof dcp, &dcp);
    }
    switch (dcp) {
    case 737: cp = cp737; break;
    case 775: cp = cp775; break;
    case 850: cp = cp850; break;
    case 852: cp = cp852; break;
    case 855: cp = cp855; break;
    case 857: cp = cp857; break;
    case 860: cp = cp860; break;
    case 861: cp = cp861; break;
    case 862: cp = cp862; break;
    case 863: cp = cp863; break;
    case 864: cp = cp864; break;
    case 865: cp = cp865; break;
    case 866: cp = cp866; break;
    case 869: cp = cp869; break;
    case 874: cp = cp874; break;
    default:
    case 437: cp = cp437; break;
    }
    for (i = 0; i < 128; i++) {
        revcp[i] = (cp[i] << 8) | i | 0x80;
    }
    qsort(revcp, lenof(revcp), sizeof *revcp, compcp);
}

int iswprint(wint_t wc) {
    uint32_t *ch, c;
    if (wc < 0x80) return isprint(wc);
    if (cp == NULL) set_cp();
    c = wc << 8;
    ch = (uint32_t *)bsearch(&c, revcp, lenof(revcp), sizeof *revcp, compcp2);
    return (ch != NULL) ? 1 : 0;
}

size_t mbrtowc(wchar_t *wc, const char *s, size_t n, mbstate_t *UNUSED(ps)) {
    uint8_t ch;
    wchar_t w;
    if (n == 0) return (size_t)-2;
    ch = *s;
    if (ch < 0x80) {
        if (!ch) return 0;
        *wc = ch;
        return 1;
    }
    if (cp == NULL) set_cp();
    *wc = w = cp[ch - 0x80];
    if (w != 0) return 1;
    errno = EILSEQ;
    return (size_t)-1;
}

size_t wcrtomb(char *s, wchar_t wc, mbstate_t *UNUSED(ps)) {
    uint32_t *ch, c;
    if (wc < 0x80) {
        *s = wc;
        return 1;
    }
    if (cp == NULL) set_cp();
    c = wc << 8;
    ch = (uint32_t *)bsearch(&c, revcp, lenof(revcp), sizeof *revcp, compcp2);
    if (ch != NULL) {
        *s = *ch;
        return 1;
    }
    errno = EILSEQ;
    return (size_t)-1;
}
#elif defined __GNUC__ || _MSC_VER >= 1400 || __WATCOMC__
#elif __STDC_VERSION__ >= 199901L && !defined __VBCC__
#else
#include <errno.h>
#include "attributes.h"

size_t mbrtowc(wchar_t *wc, const char *s, size_t n, mbstate_t *UNUSED(ps)) {
    uint8_t ch;
    if (n == 0) return (size_t)-2;
    ch = *s;
    if (ch < 0x80) {
        if (!ch) return 0;
        *wc = ch;
        return 1;
    }
    if (ch < 0xa0) {
#ifdef EILSEQ
        errno = EILSEQ;
#endif
        return (size_t)-1;
    }
    *wc = ch;
    return 1;
}

size_t wcrtomb(char *s, wchar_t wc, mbstate_t *UNUSED(ps)) {
    uint32_t *ch, c;
    if (wc < 0x80 || (wc >= 0xa0 && wc <= 0xff)) {
        *s = wc;
        return 1;
    }
#ifdef EILSEQ
    errno = EILSEQ;
#endif
    return (size_t)-1;
}
#endif

struct w16_s {
    uint16_t start;
    uint16_t end;
};

static const struct w16_s zw16[] = {
    {0x0300, 0x036F}, {0x0483, 0x0489}, {0x0591, 0x05BD}, {0x05BF, 0x05BF},
    {0x05C1, 0x05C2}, {0x05C4, 0x05C5}, {0x05C7, 0x05C7}, {0x0600, 0x0605},
    {0x0610, 0x061A}, {0x061C, 0x061C}, {0x064B, 0x065F}, {0x0670, 0x0670},
    {0x06D6, 0x06DD}, {0x06DF, 0x06E4}, {0x06E7, 0x06E8}, {0x06EA, 0x06ED},
    {0x070F, 0x070F}, {0x0711, 0x0711}, {0x0730, 0x074A}, {0x07A6, 0x07B0},
    {0x07EB, 0x07F3}, {0x07FD, 0x07FD}, {0x0816, 0x0819}, {0x081B, 0x0823},
    {0x0825, 0x0827}, {0x0829, 0x082D}, {0x0859, 0x085B}, {0x08D3, 0x0902},
    {0x093A, 0x093A}, {0x093C, 0x093C}, {0x0941, 0x0948}, {0x094D, 0x094D},
    {0x0951, 0x0957}, {0x0962, 0x0963}, {0x0981, 0x0981}, {0x09BC, 0x09BC},
    {0x09C1, 0x09C4}, {0x09CD, 0x09CD}, {0x09E2, 0x09E3}, {0x09FE, 0x09FE},
    {0x0A01, 0x0A02}, {0x0A3C, 0x0A3C}, {0x0A41, 0x0A42}, {0x0A47, 0x0A48},
    {0x0A4B, 0x0A4D}, {0x0A51, 0x0A51}, {0x0A70, 0x0A71}, {0x0A75, 0x0A75},
    {0x0A81, 0x0A82}, {0x0ABC, 0x0ABC}, {0x0AC1, 0x0AC5}, {0x0AC7, 0x0AC8},
    {0x0ACD, 0x0ACD}, {0x0AE2, 0x0AE3}, {0x0AFA, 0x0AFF}, {0x0B01, 0x0B01},
    {0x0B3C, 0x0B3C}, {0x0B3F, 0x0B3F}, {0x0B41, 0x0B44}, {0x0B4D, 0x0B4D},
    {0x0B56, 0x0B56}, {0x0B62, 0x0B63}, {0x0B82, 0x0B82}, {0x0BC0, 0x0BC0},
    {0x0BCD, 0x0BCD}, {0x0C00, 0x0C00}, {0x0C04, 0x0C04}, {0x0C3E, 0x0C40},
    {0x0C46, 0x0C48}, {0x0C4A, 0x0C4D}, {0x0C55, 0x0C56}, {0x0C62, 0x0C63},
    {0x0C81, 0x0C81}, {0x0CBC, 0x0CBC}, {0x0CBF, 0x0CBF}, {0x0CC6, 0x0CC6},
    {0x0CCC, 0x0CCD}, {0x0CE2, 0x0CE3}, {0x0D00, 0x0D01}, {0x0D3B, 0x0D3C},
    {0x0D41, 0x0D44}, {0x0D4D, 0x0D4D}, {0x0D62, 0x0D63}, {0x0DCA, 0x0DCA},
    {0x0DD2, 0x0DD4}, {0x0DD6, 0x0DD6}, {0x0E31, 0x0E31}, {0x0E34, 0x0E3A},
    {0x0E47, 0x0E4E}, {0x0EB1, 0x0EB1}, {0x0EB4, 0x0EB9}, {0x0EBB, 0x0EBC},
    {0x0EC8, 0x0ECD}, {0x0F18, 0x0F19}, {0x0F35, 0x0F35}, {0x0F37, 0x0F37},
    {0x0F39, 0x0F39}, {0x0F71, 0x0F7E}, {0x0F80, 0x0F84}, {0x0F86, 0x0F87},
    {0x0F8D, 0x0F97}, {0x0F99, 0x0FBC}, {0x0FC6, 0x0FC6}, {0x102D, 0x1030},
    {0x1032, 0x1037}, {0x1039, 0x103A}, {0x103D, 0x103E}, {0x1058, 0x1059},
    {0x105E, 0x1060}, {0x1071, 0x1074}, {0x1082, 0x1082}, {0x1085, 0x1086},
    {0x108D, 0x108D}, {0x109D, 0x109D}, {0x1160, 0x11FF}, {0x135D, 0x135F},
    {0x1712, 0x1714}, {0x1732, 0x1734}, {0x1752, 0x1753}, {0x1772, 0x1773},
    {0x17B4, 0x17B5}, {0x17B7, 0x17BD}, {0x17C6, 0x17C6}, {0x17C9, 0x17D3},
    {0x17DD, 0x17DD}, {0x180B, 0x180E}, {0x1885, 0x1886}, {0x18A9, 0x18A9},
    {0x1920, 0x1922}, {0x1927, 0x1928}, {0x1932, 0x1932}, {0x1939, 0x193B},
    {0x1A17, 0x1A18}, {0x1A1B, 0x1A1B}, {0x1A56, 0x1A56}, {0x1A58, 0x1A5E},
    {0x1A60, 0x1A60}, {0x1A62, 0x1A62}, {0x1A65, 0x1A6C}, {0x1A73, 0x1A7C},
    {0x1A7F, 0x1A7F}, {0x1AB0, 0x1ABE}, {0x1B00, 0x1B03}, {0x1B34, 0x1B34},
    {0x1B36, 0x1B3A}, {0x1B3C, 0x1B3C}, {0x1B42, 0x1B42}, {0x1B6B, 0x1B73},
    {0x1B80, 0x1B81}, {0x1BA2, 0x1BA5}, {0x1BA8, 0x1BA9}, {0x1BAB, 0x1BAD},
    {0x1BE6, 0x1BE6}, {0x1BE8, 0x1BE9}, {0x1BED, 0x1BED}, {0x1BEF, 0x1BF1},
    {0x1C2C, 0x1C33}, {0x1C36, 0x1C37}, {0x1CD0, 0x1CD2}, {0x1CD4, 0x1CE0},
    {0x1CE2, 0x1CE8}, {0x1CED, 0x1CED}, {0x1CF4, 0x1CF4}, {0x1CF8, 0x1CF9},
    {0x1DC0, 0x1DF9}, {0x1DFB, 0x1DFF}, {0x200B, 0x200F}, {0x202A, 0x202E},
    {0x2060, 0x2064}, {0x2066, 0x206F}, {0x20D0, 0x20F0}, {0x2CEF, 0x2CF1},
    {0x2D7F, 0x2D7F}, {0x2DE0, 0x2DFF}, {0x302A, 0x302D}, {0x3099, 0x309A},
    {0xA66F, 0xA672}, {0xA674, 0xA67D}, {0xA69E, 0xA69F}, {0xA6F0, 0xA6F1},
    {0xA802, 0xA802}, {0xA806, 0xA806}, {0xA80B, 0xA80B}, {0xA825, 0xA826},
    {0xA8C4, 0xA8C5}, {0xA8E0, 0xA8F1}, {0xA8FF, 0xA8FF}, {0xA926, 0xA92D},
    {0xA947, 0xA951}, {0xA980, 0xA982}, {0xA9B3, 0xA9B3}, {0xA9B6, 0xA9B9},
    {0xA9BC, 0xA9BC}, {0xA9E5, 0xA9E5}, {0xAA29, 0xAA2E}, {0xAA31, 0xAA32},
    {0xAA35, 0xAA36}, {0xAA43, 0xAA43}, {0xAA4C, 0xAA4C}, {0xAA7C, 0xAA7C},
    {0xAAB0, 0xAAB0}, {0xAAB2, 0xAAB4}, {0xAAB7, 0xAAB8}, {0xAABE, 0xAABF},
    {0xAAC1, 0xAAC1}, {0xAAEC, 0xAAED}, {0xAAF6, 0xAAF6}, {0xABE5, 0xABE5},
    {0xABE8, 0xABE8}, {0xABED, 0xABED}, {0xFB1E, 0xFB1E}, {0xFE00, 0xFE0F},
    {0xFE20, 0xFE2F}, {0xFEFF, 0xFEFF}, {0xFFF9, 0xFFFB},
};

static const struct w16_s dw16[] = {
    {0x1100, 0x115F}, {0x231A, 0x231B}, {0x2329, 0x232A}, {0x23E9, 0x23EC},
    {0x23F0, 0x23F0}, {0x23F3, 0x23F3}, {0x25FD, 0x25FE}, {0x2614, 0x2615},
    {0x2648, 0x2653}, {0x267F, 0x267F}, {0x2693, 0x2693}, {0x26A1, 0x26A1},
    {0x26AA, 0x26AB}, {0x26BD, 0x26BE}, {0x26C4, 0x26C5}, {0x26CE, 0x26CE},
    {0x26D4, 0x26D4}, {0x26EA, 0x26EA}, {0x26F2, 0x26F3}, {0x26F5, 0x26F5},
    {0x26FA, 0x26FA}, {0x26FD, 0x26FD}, {0x2705, 0x2705}, {0x270A, 0x270B},
    {0x2728, 0x2728}, {0x274C, 0x274C}, {0x274E, 0x274E}, {0x2753, 0x2755},
    {0x2757, 0x2757}, {0x2795, 0x2797}, {0x27B0, 0x27B0}, {0x27BF, 0x27BF},
    {0x2B1B, 0x2B1C}, {0x2B50, 0x2B50}, {0x2B55, 0x2B55}, {0x2E80, 0x2E99},
    {0x2E9B, 0x2EF3}, {0x2F00, 0x2FD5}, {0x2FF0, 0x2FFB}, {0x3000, 0x303E},
    {0x3041, 0x3096}, {0x3099, 0x30FF}, {0x3105, 0x312F}, {0x3131, 0x318E},
    {0x3190, 0x31BA}, {0x31C0, 0x31E3}, {0x31F0, 0x321E}, {0x3220, 0x3247},
    {0x3250, 0x32FE}, {0x3300, 0x4DBF}, {0x4E00, 0xA48C}, {0xA490, 0xA4C6},
    {0xA960, 0xA97C}, {0xAC00, 0xD7A3}, {0xF900, 0xFAFF}, {0xFE10, 0xFE19},
    {0xFE30, 0xFE52}, {0xFE54, 0xFE66}, {0xFE68, 0xFE6B}, {0xFF01, 0xFF60},
    {0xFFE0, 0xFFE6},
};

struct w32_s {
    uint32_t start;
    uint32_t end;
};

static const struct w32_s zw32[] = {
    {0x101FD, 0x101FD}, {0x102E0, 0x102E0}, {0x10376, 0x1037A},
    {0x10A01, 0x10A03}, {0x10A05, 0x10A06}, {0x10A0C, 0x10A0F},
    {0x10A38, 0x10A3A}, {0x10A3F, 0x10A3F}, {0x10AE5, 0x10AE6},
    {0x10D24, 0x10D27}, {0x10F46, 0x10F50}, {0x11001, 0x11001},
    {0x11038, 0x11046}, {0x1107F, 0x11081}, {0x110B3, 0x110B6},
    {0x110B9, 0x110BA}, {0x110BD, 0x110BD}, {0x110CD, 0x110CD},
    {0x11100, 0x11102}, {0x11127, 0x1112B}, {0x1112D, 0x11134},
    {0x11173, 0x11173}, {0x11180, 0x11181}, {0x111B6, 0x111BE},
    {0x111C9, 0x111CC}, {0x1122F, 0x11231}, {0x11234, 0x11234},
    {0x11236, 0x11237}, {0x1123E, 0x1123E}, {0x112DF, 0x112DF},
    {0x112E3, 0x112EA}, {0x11300, 0x11301}, {0x1133B, 0x1133C},
    {0x11340, 0x11340}, {0x11366, 0x1136C}, {0x11370, 0x11374},
    {0x11438, 0x1143F}, {0x11442, 0x11444}, {0x11446, 0x11446},
    {0x1145E, 0x1145E}, {0x114B3, 0x114B8}, {0x114BA, 0x114BA},
    {0x114BF, 0x114C0}, {0x114C2, 0x114C3}, {0x115B2, 0x115B5},
    {0x115BC, 0x115BD}, {0x115BF, 0x115C0}, {0x115DC, 0x115DD},
    {0x11633, 0x1163A}, {0x1163D, 0x1163D}, {0x1163F, 0x11640},
    {0x116AB, 0x116AB}, {0x116AD, 0x116AD}, {0x116B0, 0x116B5},
    {0x116B7, 0x116B7}, {0x1171D, 0x1171F}, {0x11722, 0x11725},
    {0x11727, 0x1172B}, {0x1182F, 0x11837}, {0x11839, 0x1183A},
    {0x11A01, 0x11A0A}, {0x11A33, 0x11A38}, {0x11A3B, 0x11A3E},
    {0x11A47, 0x11A47}, {0x11A51, 0x11A56}, {0x11A59, 0x11A5B},
    {0x11A8A, 0x11A96}, {0x11A98, 0x11A99}, {0x11C30, 0x11C36},
    {0x11C38, 0x11C3D}, {0x11C3F, 0x11C3F}, {0x11C92, 0x11CA7},
    {0x11CAA, 0x11CB0}, {0x11CB2, 0x11CB3}, {0x11CB5, 0x11CB6},
    {0x11D31, 0x11D36}, {0x11D3A, 0x11D3A}, {0x11D3C, 0x11D3D},
    {0x11D3F, 0x11D45}, {0x11D47, 0x11D47}, {0x11D90, 0x11D91},
    {0x11D95, 0x11D95}, {0x11D97, 0x11D97}, {0x11EF3, 0x11EF4},
    {0x16AF0, 0x16AF4}, {0x16B30, 0x16B36}, {0x16F8F, 0x16F92},
    {0x1BC9D, 0x1BC9E}, {0x1BCA0, 0x1BCA3}, {0x1D167, 0x1D169},
    {0x1D173, 0x1D182}, {0x1D185, 0x1D18B}, {0x1D1AA, 0x1D1AD},
    {0x1D242, 0x1D244}, {0x1DA00, 0x1DA36}, {0x1DA3B, 0x1DA6C},
    {0x1DA75, 0x1DA75}, {0x1DA84, 0x1DA84}, {0x1DA9B, 0x1DA9F},
    {0x1DAA1, 0x1DAAF}, {0x1E000, 0x1E006}, {0x1E008, 0x1E018},
    {0x1E01B, 0x1E021}, {0x1E023, 0x1E024}, {0x1E026, 0x1E02A},
    {0x1E8D0, 0x1E8D6}, {0x1E944, 0x1E94A}, {0xE0001, 0xE0001},
    {0xE0020, 0xE007F}, {0xE0100, 0xE01EF},
};

static const struct w32_s dw32[] = {
    {0x16FE0, 0x16FE1}, {0x17000, 0x187F1}, {0x18800, 0x18AF2},
    {0x1B000, 0x1B11E}, {0x1B170, 0x1B2FB}, {0x1F004, 0x1F004},
    {0x1F0CF, 0x1F0CF}, {0x1F18E, 0x1F18E}, {0x1F191, 0x1F19A},
    {0x1F200, 0x1F202}, {0x1F210, 0x1F23B}, {0x1F240, 0x1F248},
    {0x1F250, 0x1F251}, {0x1F260, 0x1F265}, {0x1F300, 0x1F320},
    {0x1F32D, 0x1F335}, {0x1F337, 0x1F37C}, {0x1F37E, 0x1F393},
    {0x1F3A0, 0x1F3CA}, {0x1F3CF, 0x1F3D3}, {0x1F3E0, 0x1F3F0},
    {0x1F3F4, 0x1F3F4}, {0x1F3F8, 0x1F43E}, {0x1F440, 0x1F440},
    {0x1F442, 0x1F4FC}, {0x1F4FF, 0x1F53D}, {0x1F54B, 0x1F54E},
    {0x1F550, 0x1F567}, {0x1F57A, 0x1F57A}, {0x1F595, 0x1F596},
    {0x1F5A4, 0x1F5A4}, {0x1F5FB, 0x1F64F}, {0x1F680, 0x1F6C5},
    {0x1F6CC, 0x1F6CC}, {0x1F6D0, 0x1F6D2}, {0x1F6EB, 0x1F6EC},
    {0x1F6F4, 0x1F6F9}, {0x1F910, 0x1F93E}, {0x1F940, 0x1F970},
    {0x1F973, 0x1F976}, {0x1F97A, 0x1F97A}, {0x1F97C, 0x1F9A2},
    {0x1F9B0, 0x1F9B9}, {0x1F9C0, 0x1F9C2}, {0x1F9D0, 0x1F9FF},
    {0x20000, 0x2FFFD}, {0x30000, 0x3FFFD},
};

static int compw16(const void *aa, const void *bb) {
    uchar_t key = *(const uchar_t *)aa;
    const struct w16_s *b = (const struct w16_s *)bb;

    if (key > b->end) return 1;
    if (key < b->start) return -1;
    return 0;
}

static int compw32(const void *aa, const void *bb) {
    uchar_t key = *(const uchar_t *)aa;
    const struct w32_s *b = (const struct w32_s *)bb;

    if (key > b->end) return 1;
    if (key < b->start) return -1;
    return 0;
}

int wcwidth_v9(uchar_t ch) {
    if (ch < 0x300) return 1;

    if (ch < 0x10000) {
        if (bsearch(&ch, zw16, lenof(zw16), sizeof *zw16, compw16) != NULL) return 0;
        if (ch < 0x1100) return 1;
        if (bsearch(&ch, dw16, lenof(dw16), sizeof *dw16, compw16) != NULL) return 2;
        return 1;
    }

    if (bsearch(&ch, zw32, lenof(zw32), sizeof *zw32, compw32) != NULL) return 0;
    if (bsearch(&ch, dw32, lenof(dw32), sizeof *dw32, compw32) != NULL) return 2;
    return 1;
}