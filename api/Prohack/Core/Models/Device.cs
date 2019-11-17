using Newtonsoft.Json;
using Prohack.Core.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Prohack.Core
{
    public class Device
    {
        public int Id { get; set; }
        public int MineId { get; set; }
        public string DeviceId { get; set; }
        public Mine Mine { get; set; }
        public int? X { get; set; }
        public int? Y { get; set; }

        [JsonIgnore]
        public List<Data> Datas { get; set; }
    }
}
