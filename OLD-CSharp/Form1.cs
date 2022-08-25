using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;
using System.Management.Instrumentation;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Collections;
using System.Collections.ObjectModel;

namespace RestartWebsiteAndAppPool
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();

        }

        private string RunScript(string script)
        {
            Runspace runspace = RunspaceFactory.CreateRunspace();
            runspace.Open();
            Pipeline pipeline = runspace.CreatePipeline();
            pipeline.Commands.AddScript(script);
            pipeline.Commands.Add("Out-String");
            Collection<PSObject> results = pipeline.Invoke();
            runspace.Close();
            StringBuilder stringBuilder = new StringBuilder();
            foreach (PSObject pSObject in results)
                stringBuilder.AppendLine(pSObject.ToString());
            return stringBuilder.ToString();
            
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {

                textBox2.Clear();
                textBox2.Text = RunScript(textBox1.Text);
               
            }
            catch (Exception ex)
            {
                textBox2.Text = ex.ToString();
            }
        }

        //public: void WriteObject(System::Object ^ sendToPipeline, bool enumerateCollection);

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            this.AcceptButton = button1;
        }
    }
}
