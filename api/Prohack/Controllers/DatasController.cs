using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Prohack.Core;
using Prohack.Core.Models;

namespace Prohack.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class DatasController : ControllerBase
    {


        private readonly ILogger<DatasController> _logger;

        private readonly DatabaseContext _context;

        public DatasController(ILogger<DatasController> logger, DatabaseContext context)
        {
            _logger = logger;
            _context = context;
        }

        [HttpGet]
        public IEnumerable<Data> Get(int deviceId)
        {
            return _context.Datas.Where(i => i.DeviceId == deviceId).ToList();
        }

        [HttpPost]
        public bool Post([FromBody] DeviceRequest model)
        {
            //091AFF0CA8FF036A
            //"CRr/DKj/A2o="
            var msg = model.payload_raw;
            var bytes = System.Convert.FromBase64String(msg);
            var deviceId = model.dev_id;
            var device = _context.Devices.FirstOrDefault(i => i.DeviceId == deviceId);
            var data = new Data() { DeviceId  = device.Id, Date = DateTime.UtcNow };

            if (model.port == 2)
            {
                double t = int.Parse(BitConverter.ToString(new byte[2] { bytes[0], bytes[1] }).Replace("-", ""), System.Globalization.NumberStyles.HexNumber) / 100.0;
                double h = int.Parse(BitConverter.ToString(new byte[2] { bytes[3], bytes[4] }).Replace("-", ""), System.Globalization.NumberStyles.HexNumber) / 100.0;
                double gas = int.Parse(BitConverter.ToString(new byte[2] { bytes[6], bytes[7] }).Replace("-", ""), System.Globalization.NumberStyles.HexNumber);
                data.T = t;
                data.H = h;
                data.Gas = gas;
                

            }
            if (model.port == 4)
            {
                double co = int.Parse(BitConverter.ToString(new byte[2] { bytes[0], bytes[1] }).Replace("-", ""), System.Globalization.NumberStyles.HexNumber) / 100.0;
                data.Co = co;
                var turbine = _context.Turbines.Include(i => i.Device).Include(i => i.Device.Datas).FirstOrDefault(i => i.DeviceId == device.Id);
                if (turbine != null) {
                    using (var httpClient = new HttpClient())
                    {
                        if (!turbine.UseManual)
                        {
                            turbine.Status = TurbineLogic.GetStatus(turbine);
                        }
                        var turbineValue = Convert.ToBase64String(new byte[1] { Convert.ToByte(turbine.Status) });
                        var content = new StringContent("{\"dev_id\":\"" + model.dev_id + "\",\"payload_raw\":\""+ turbineValue +"\"}", Encoding.UTF8, "application/json");

                        var temp= httpClient.PostAsync(model.downlink_url, content).Result;
                    }
                }
            }
            if (model.port == 3)
            {
                data.Persons = 1;
            }
            _context.Update(data);
            _context.SaveChanges();
            return true;
        }
    }
}
