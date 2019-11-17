using Prohack.Core.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Prohack.Core
{
    public class Turbine
    {
        public int Id { get; set; }
        public int MineId { get; set; }
        public Mine Mine { get; set; }
        public int? DeviceId { get; set; }
        public Device Device { get; set; }
        public int Status { get; set; }
        public bool UseManual { get; set; }
        public int X { get; set; }
        public int Y { get; set; }
    }
}
