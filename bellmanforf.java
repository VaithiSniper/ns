import java.util.*;
public class bellmanforf {
	public static final int MAX = 999;
	public int distance[];
	public int n;
	
	public bellmanforf(int n2) {
		n = n2;
		distance = new int[n+1];
	}

	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		System.out.println("Enter the number of verts");
		int n = sc.nextInt();
		int adj[][] = new int[n+1][n+1];
		System.out.println("Enter the adj matrix");
		
		for(int i=1;i<=n;i++)
		{
			for(int j=1;j<=n;j++)
			{
				adj[i][j] = sc.nextInt();
				if(i==j)
				{
					adj[i][j]=0;
					continue;
				}
				if(adj[i][j]==0)
					adj[i][j]=MAX;
			}
		}
		
		for(int i=1;i<=n;i++)
		{
			bellmanforf b = new bellmanforf(n);
			b.bellmanFordEval(i,adj);
		}
		sc.close();
	}
	
	private void bellmanFordEval(int src, int[][] adj) {
		for(int i=1;i<=n;i++)
			distance[i]=MAX;
		distance[src]=0;
		
		for(int i=1;i<=n-1;i++)
		{
			for(int snode=1;snode<=n;snode++)
			{
				for(int dnode=1;dnode<=n;dnode++)
				{
					int dist;
					if(adj[snode][dnode]!=MAX)
					{
						if((dist=distance[snode]+adj[snode][dnode])<distance[dnode])
							distance[dnode] = dist;
					}
				}
			}
		}
		//check loop
		for(int snode=1;snode<=n;snode++)
		{
			for(int dnode=1;dnode<=n;dnode++)
			{
				int dist;
				if(adj[snode][dnode]!=MAX)
				{
					if((dist=distance[snode]+adj[snode][dnode])<distance[dnode])
						{
							System.out.print("Graph has negative edge loops");
							return;
						}
				}
			}
		}
		
		System.out.println("Routing table info for "+src);
		System.out.println("Destination\tDistance");
		
		int i=1;
		for(int d: distance)
		{
			System.out.println(i++ + "\t" + d); 
		}
		
	}
}
