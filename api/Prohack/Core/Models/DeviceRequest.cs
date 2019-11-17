using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Prohack.Core.Models
{
    public class DeviceRequest
    {
        public string app_id { get; set; }
        public string dev_id { get; set; }
        public string hardware_serial { get; set; }
        public int port { get; set; }
        public int counter { get; set; }
        public bool confirmed { get; set; }
        public string payload_raw { get; set; }
        public string downlink_url { get; set; }
    }


}
