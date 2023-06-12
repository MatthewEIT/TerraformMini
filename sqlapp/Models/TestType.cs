using sqlapp.Services;
using sqlapp.Models;
namespace sqlapp.Models
{
    public class TestType
    {
        public static bool TestTypeInt1(int a)
        {
            Product product = new Product();
            int b = product.ProductID;
            if (a.GetType() == b.GetType()) { return true; } else { return false; }


        }
   //     public static bool TestTypeInt2(int a)
     //   {
       //     Product product2 = new Product();
         //   string b = product2.ProductName;
           // if (a.GetType() == b.GetType()) { return true; } else { return false; }
        //}
    }
}