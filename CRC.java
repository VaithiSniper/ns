import java.util.*;

public class CRC {
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		String zeros = "0000000000000000";
		System.out.println("Enter the dataword");
		String input = sc.nextLine();
		int datan = input.length();
		String dividend = input + zeros;
		String codeword = CRCCompute(dividend, datan);
		System.out.println("Dataword : "+input);
		System.out.println("Codeword : "+input+codeword.substring(datan));
		System.out.println("CRC : "+codeword.substring(datan));
		System.out.println("Enter received data : ");
		String recv = sc.nextLine();
		if(zeros.equals(CRCCompute(recv, datan).substring(datan)))
			System.out.println("Correct bits received");
		else
		    System.out.println("Error occured during transmission");
		sc.close();
	}
	
	public static String CRCCompute(String dividend, int n) {
		String div = "10001000000010001";
		for(int i=0;i<n;i++)
		{
			char x = dividend.charAt(i);
			for(int j=0;j<17;j++)
			{
				if(x=='1') {
					if(dividend.charAt(i+j)==div.charAt(j))
						dividend = dividend.substring(0, i+j) + "0" + dividend.substring(i+j+1);
					else
						dividend = dividend.substring(0, i+j) + "1" + dividend.substring(i+j+1);
				}
			}
		}
		return dividend;
	}

}
