using Prohack.Core.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Prohack.Core
{
    public class DataLogic
    {
        public static DeviceDataSummary GetSummaryForDevice(Device device)
        {

            var datas = device.Datas != null && device.Datas.Any() ? device.Datas.Where(i => i.Date > DateTime.UtcNow.AddMinutes(-1)).ToList() : new List<Data>();
            if (datas.Any())
            {
                return new DeviceDataSummary
                {
                    Date = datas.Max(i => i.Date),
                    Co = datas.Where(i => i.Co != null)?.Max(i => i.Co),
                    T = datas.Where(i => i.T != null)?.Average(i => i.T),
                    H = datas.Where(i => i.H != null)?.Average(i => i.H),
                    Gas = datas.Where(i => i.Gas != null)?.Average(i => i.Gas),
                    Persons = datas.Where(i => i.Persons != null)?.Max(i => i.Persons),
                };
            }
            return null;

        }
    }
}
