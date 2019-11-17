using Newtonsoft.Json;
using Prohack.Core.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Prohack.Core
{
    public class DeviceViewModel
    {
        public int Id { get; set; }
        public int MineId { get; set; }
        public string DeviceId { get; set; }
        public int? X { get; set; }
        public int? Y { get; set; }

        public DeviceDataSummary Data { get; set; }

        public DeviceViewModel(Device device)
        {

            this.DeviceId = device.DeviceId;
            this.Id = device.Id;
            this.MineId = device.MineId;
            this.X = device.X;
            this.Y = device.Y;
            this.Data = DataLogic.GetSummaryForDevice(device);
        }
    }
}
