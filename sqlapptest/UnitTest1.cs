using sqlapp.Models;
using sqlapp.Services;
using Xunit.Sdk;

namespace sqlapptest
{
    public class TypeValidation
    {
        [Fact]
        public void TypeTest1()
        {
            int a = 15;
            Assert.True(TestType.TestTypeInt1(a));
        }
        //[Fact]
        //    public void TypeTest2()
        //    {
        //        int b = 20;
        //        Assert.True(TestType.TestTypeInt2(b));
        //    }
    }
}