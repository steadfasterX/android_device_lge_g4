/*
   Copyright (c) 2013, The Linux Foundation. All rights reserved.
   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.
   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdlib.h>

#include "vendor_init.h"
#include "property_service.h"
#include "util.h"

#define CMDLINE_MODEL        "model.name="
#define CMDLINE_MODEL_LEN    (strlen(CMDLINE_MODEL))
#define DEVID_MAX 48

char product_model[PROP_VALUE_MAX];

void sanitize_product_model(void) {
        const char* whitelist ="-._";
        char str[DEVID_MAX];
        char* c = str;

        snprintf(str, DEVID_MAX, "%s", product_model);
        memset(product_model, 0, strlen(product_model));
        while (*c) {
                if (isalnum(*c) || strchr(whitelist, *c))
                        strncat(product_model, c, 1);
                c++;
        }
        return;
}

void get_device_model(void)
{
    FILE *fp;
    char line[2048];
    char* token;

    // Check the cmdline to see if the serial number was supplied
    fp = fopen("/proc/cmdline", "rt");
    if (fp != NULL) {
        fgets(line, sizeof(line), fp);
        fclose(fp); // cmdline is only one line long

        token = strtok(line, " ");
        while (token) {
            if (memcmp(token, CMDLINE_MODEL, CMDLINE_MODEL_LEN) == 0) {
                token += CMDLINE_MODEL_LEN;
                snprintf(product_model, DEVID_MAX, "%s", token);
                sanitize_product_model(); // also removes newlines
                return;
            }
            token = strtok(NULL, " ");
        }
     }
     strcpy(product_model, "NOBLMODEL"); // bootloader hasn't provided the model name
     return;
}

void vendor_load_properties()
{
    char product_name[PROP_VALUE_MAX];
    char product_device[PROP_VALUE_MAX];
    char build_product[PROP_VALUE_MAX];

    get_device_model();

    // Check what device types we have and set their prop accordingly
    //if (strstr(product_device,"h815")||strstr(product_name,"p1_global_com")||strstr(product_name,"g4_global_com")) {
    if (strstr(product_model,"LG-H815")) {
         // if its global then it has to be H815
        property_set("ro.product.model","LG-H815");
        property_set("ro.product.name","p1_global_com");
        property_set("ro.product.device","h815");
        property_set("ro.build.product","h815");
    } else if (strstr(product_model,"LG-H811")) {
        property_set("ro.product.model","LG-H811");
        property_set("ro.product.name","p1_tmo_us");
        property_set("ro.product.device","h811");
        property_set("ro.build.product","h811");
    // Check WHETHER we got another device
    } else {
        //The wont work on other devices so just let them be their own props
        //property_set("ro.product.model",product_model);
        property_set("ro.product.model","DETECTFAILED");
        property_set("ro.product.name",product_name);
        property_set("ro.product.device",product_device);
        property_set("ro.build.product",build_product);
    }
}
