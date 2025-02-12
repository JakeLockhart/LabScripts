#include "PowerResults.h"

// Wavelengths
WavelengthList data_WavelengthList[] = {
    {1000, 1020, 920, 940}
};

// Voltage Values
PowerResults data_PowerResults[] = {
{0,	    {2.0014,    1.1912,     1.5998,     1.5714 }},
{5,	    {2.4048,    1.4021,     2.0227,     2.0356 }},
{10,	{3.2540,    2.3226,     2.4811,     2.6907 }},
{15,	{4.1247,    3.6740,     3.2815,     1.4129 }},
{20,	{4.8909,    3.2268,     4.6525,     3.3276 }},
{25,	{6.2281,    5.7224,     6.4109,     5.4461 }},
{30,	{7.2038,    3.7936,     7.9559,     6.8793 }},
{35,	{3.8398,    8.9121,     10.4390,    8.9193 }},
{40,	{10.8040,   11.086,     12.5400,    11.7898}},
{45,	{13.4390,   13.142,     16.3340,    14.9870}},
{50,	{15.9140,   15.490,     19.5280,    17.7500}},
{55,	{18.9820,   17.923,     22.9190,    20.5067}},
{60,	{21.2980,   20.383,     26.8010,    23.8140}},
{65,	{24.0782,   22.478,     30.3385,    26.2869}},
{70,	{26.7055,   24.296,     33.0280,    29.1767}},
{80,	{30.3080,   27.679,     36.9970,    33.3156}},
{90,	{32.2460,   28.866,     39.1630,    35.4774}},
{100,	{30.6720,   28.179,     38.0440,    34.8060}},
};

const int data_PowerResults_size = sizeof(data_PowerResults) / sizeof(data_PowerResults[0]);
const int data_WavelengthList_size = sizeof(data_WavelengthList) / sizeof(data_WavelengthList[0]);
