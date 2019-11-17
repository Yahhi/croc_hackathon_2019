using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Prohack.Core.Models
{
    public class DeviceDataSummary
    {

        public double? Co { get; set; }
        public double? T { get; set; }
        public double? H { get; set; }
        public double? Gas { get; set; }
        public int? Persons { get; set; }
        public DateTime Date { get; set; }
    }
}
