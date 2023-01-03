import java.math.*;
import java.util.*;
public class RSA {
	static BigInteger p,q,n,phi,e,d;
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int bitLength = 256;
		Random r = new Random();
		p = BigInteger.probablePrime(bitLength, r);
		q = BigInteger.probablePrime(bitLength, r);
		n = p.multiply(q);
		phi = (p.subtract(BigInteger.ONE)).multiply(q.subtract(BigInteger.ONE));
		e = BigInteger.probablePrime(bitLength/2, r);
		while(((phi.gcd(e)).compareTo(BigInteger.ONE))!=0 && e.compareTo(phi)<0)
			e.add(BigInteger.ONE);
		d = e.modInverse(phi);
		System.out.println("Enter message");
		String msg = sc.nextLine();
		byte[] msgArr = msg.getBytes();
		display(msgArr, "Messsage");
		byte[] en = encrypt(msgArr);
		display(en, "Encrypted");
		byte[] de = decrypt(en);
		display(de, "Decrypted");
		System.out.println(new String(de)); 
	}
	
	private static byte[] decrypt(byte[] en) {
		return new BigInteger(en).modPow(d, n).toByteArray();
	}

	private static byte[] encrypt(byte[] msgArr) {
		return new BigInteger(msgArr).modPow(e, n).toByteArray();
	}

	public static void display(byte[] msgArr, String type) {
		System.out.println(type + " byte array : ");
		for(byte i : msgArr)
		{
			System.out.print(i);
		}
		System.out.println();	
	}
	
}
