#ifndef DATA_H
#define DATA_h


// Define table structure
struct PowerResults {
    float InputIntensity;
    float LaserIntensity[4];
};

// Declare table array
PowerResults data[] = {
{0,	    {2.0014,        	1.1912,         	1.5998, 	1.5714}},
{5,	    {2.404875,      	1.4021,         	2.02275,    2.035685}},
{10,	{3.25405,       	2.32264,            2.4811, 	2.69074}},
{15,	{4.12475,       	3.674,          	3.2815, 	1.41294}},
{20,	{4.8909,        	3.22686000000001,   4.6525, 	3.32762}},
{25,	{6.22815,       	5.7224,         	6.41095,    5.44615}},
{30,	{7.2038,        	3.79362000000001,   7.9559, 	6.87933}},
{35,	{3.83985000000003,  8.91216,            10.439, 	8.9193}},
{40,	{10.804,        	11.086,         	12.54,  	11.7898}},
{45,	{13.439,        	13.142,         	16.334, 	14.987}},
{50,	{15.914,        	15.49,          	19.528, 	17.75}},
{55,	{18.982,        	17.923,         	22.919, 	20.50675}},
{60,	{21.298,        	20.3832,            26.801, 	23.814}},
{65,	{24.07825,      	22.4786,            30.3385,    26.28695}},
{70,	{26.7055,       	24.2962,            33.028, 	29.1767}},
{80,	{30.308,        	27.6796,            36.997, 	33.3156}},
{90,	{32.246,        	28.8664,            39.163, 	35.4774}},
{100,	{30.672,        	28.179,         	38.044, 	34.806}},
};

#endif
