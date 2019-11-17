using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Prohack.Core.Models
{
    public class Mine
    {
        public int Id { get; set; }
        public string Map { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        public string Name { get; set; }
        public List<Turbine> Turbines { get; set; }
    }
}
